
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
{ Modules } = require("meteor/noorahealth:mongo-schemas")

{ AppState } = require('../../api/AppState.coffee')
{ Award } = require('../components/lesson/popups/award.coffee')
{ BonusVideoPopup } = require('../components/lesson/popups/watchBonusVideo.coffee')
{ ContentInterface }= require('../../api/content/ContentInterface.coffee')
{ TAPi18n } = require("meteor/tap:i18n")

require './lesson_view.html'
require '../components/lesson/modules/binary.coffee'
require '../components/lesson/modules/scenario.coffee'
require '../components/lesson/modules/multiple_choice/multiple_choice.coffee'
require '../components/lesson/modules/slide.html'
require '../components/lesson/modules/video.coffee'
require '../components/lesson/footer/footer.coffee'

Template.Lesson_view_page.onCreated ()->

  language = AppState.getLanguage()
  console.log "Setting the language to #{language.toLowerCase()}"
  
  console.log "Supported language "
  console.log TAPi18n.getLanguages()
  console.log TAPi18n
  TAPi18n.setLanguage(language.toLowerCase())

  @state = new ReactiveDict()
  @state.setDefault {
    moduleIndex: 0
    currentModuleId: null
    correctlySelectedClasses: 'correctly-selected expanded'
    incorrectClasses: 'faded'
    incorrectlySelectedClasses: 'incorrectly-selected'
    nextButtonAnimated: false
    soundEfffectPlaying: null
    audioPlaying: "QUESTION"
    lessonIndex: 0
  }

  @incorrectResponses = []

  @getCurrentModuleId = =>
    @state.get "currentModuleId"

  @setCurrentModuleId = =>
    index = @state.get "moduleIndex"
    lesson = @getLesson()
    moduleId = lesson?.modules[index]
    @state.set "currentModuleId", moduleId

  @getCurrentModule = =>
    id = @getCurrentModuleId()
    return Modules.findOne {_id: id}

  @isCurrent = (moduleId) =>
    current = @getCurrentModuleId()
    return moduleId is current

  @isCompleted = (moduleId) =>
    modules = @getLesson()?.modules
    index = @state.get "moduleIndex"
    return index > modules?.indexOf moduleId

  @trackAudioStopped = (pos, completed, src) =>
    lesson = @getLesson()
    condition = AppState.getCondition()
    language = AppState.getLanguage()
    module = @getCurrentModule()
    text = if module.title then module.title else module.question
    analytics.track "Audio Stopped", {
      moduleText: text
      audioSrc: src
      moduleId: module._id
      language: language
      condition: condition
      time: pos
      completed: completed
      lessonTitle: lesson.title
      lessonId: lesson._id
    }

  @answeredIncorrectly = ( id )=>
    return id in @incorrectResponses

  @getPagesForPaginator = =>
    modules = @getModules()
    if not modules?
      return []
    else
      getPageData = (module, i) =>
        data = {
          completed: @isCompleted module._id
          current: @isCurrent module._id
          incorrect: @answeredIncorrectly module._id
          index: i+1
        }
        return data
      pages = ( getPageData(module, i) for module, i in modules )
      return pages

  @onFinishExplanation = (pos, completed, src) =>
    @state.set "nextButtonAnimated", true
    @trackAudioStopped( pos, completed, src)

  @onChoice = (instance, type, showAlert) ->
    return (choice) ->
      if type is "CORRECT"
        instance.state.set "soundEfffectPlaying", "CORRECT"
        alertType = 'success'
      else
        instance.state.set "soundEfffectPlaying", "INCORRECT"
        alertType = 'error'
        module = instance.getCurrentModule()
        if not (module._id in instance.incorrectResponses)
          instance.incorrectResponses.push module._id
      if showAlert
        swal {
          title: ""
          type: alertType
          timer: 3000
        }

      #analytics
      lesson = instance.getLesson()
      condition = AppState.getCondition()
      language = AppState.getLanguage()
      module = instance.getCurrentModule()
      text = if module.title then module.title else module.question
      analytics.track "Responded to Question", {
        moduleId: module._id
        moduleText: text
        choice: choice
        lessonTitle: lesson.title
        lessonId: lesson._id
        condition: condition
        language: language
        type: type
      }

  @onCompletedQuestion = (instance) ->
    return ->
      instance.state.set "audioPlaying", "EXPLANATION"

  @stopPlayingSoundEffect = =>
    @state.set "soundEfffectPlaying", null

  @lessonComplete = =>
    lesson = @getLesson()
    index = @state.get "moduleIndex"
    return index == lesson?.modules?.length-1

  @secondToLastModule = =>
    lesson = @getLesson()
    index = @state.get "moduleIndex"
    return index == lesson?.modules?.length-2

  @getModules = =>
    return @getLesson()?.getModulesSequence()

  @getLessonId = =>
    #return AppState.getLessonId()
    index = @state.get "lessonIndex"
    level = @getLevel()
    return @lessons()?[index]

  @getLesson = =>
    id = @getLessonId()
    lesson = Lessons.findOne { _id: id }
    return lesson

  @getLevel = =>
    return FlowRouter.getParam( "level" )

  @lessons = =>
    level = @getLevel()
    return AppState.getLessons( level )
  
  @isLastLesson = =>
    lessonIndex = @state.get "lessonIndex"
    return lessonIndex == @lessons().length - 1


  @celebrateCompletion = =>
    lessonIndex = @state.get "lessonIndex"
    lessonsComplete = lessonIndex + 1
    totalLessons = @lessons().length
    onConfirm = ()=>
      @goToNextLesson()

    onCancel = ()=>
      @goHome(null, false)
    
    isLastLesson = @isLastLesson()
    console.log "Is last lesson ", isLastLesson
    if @isLastLesson()
      console.log "Is last lesson"
      new Award().sendAward( null, null, lessonsComplete, totalLessons)
      @goHome( null, true )
    else
      console.log "Not last lesson"
      new Award().sendAward( onConfirm, onCancel, lessonsComplete, totalLessons )

  @incrementLesson = =>
    lessonIndex = @state.get "lessonIndex"
    @state.set "lessonIndex", lessonIndex + 1

  @goToNextLesson = =>
    if @isLastLesson()
      @goHome(null, false)
    else
      @incrementLesson()
      @incorrectResponses = []
      @displayModule(0)

  @offerBonusVideo = =>
    console.log "Offering bonus video!!"
    onConfirm = =>
      #@playVideo()

    onCancel = =>
      #data.onCancel()
      @goToNextLesson()

    aFewWrong = @incorrectResponses.length > 1
    new BonusVideoPopup().display onConfirm, onCancel, aFewWrong
      
  @goHome = ( event, completedCurriculum) =>
    lesson = @getLesson()
    module = @getCurrentModule()
    text = if module?.title then module?.title else module?.question
    analytics.track "Left Lesson For Home", {
      lessonTitle: lesson?.title
      lessonId: lesson?._id
      lastModuleId: module?._id
      lastModuleText: text
      lastModuleType: module?.type
      completedCurriculum: completedCurriculum
      numberOfModulesInLesson: lesson?.modules.length
    }
    AppState.incrementLevel()
    FlowRouter.go "home"

  @displayModule = (index) =>
    console.log "Displaying module #{index}"
    @state.set "moduleIndex", index
    @state.set "nextButtonAnimated", false
    @state.set "audioPlaying", "QUESTION"
    @setCurrentModuleId()
    console.log "Slideing to #{index}"
    console.log @swiper
    @swiper.slideTo index
    module = @getCurrentModule()
    if @isBonus module
      @offerBonusVideo()

  @goToNextModule = =>
    console.log "Going to the next module"
    index = @state.get "moduleIndex"
    newIndex = ++index
    console.log "Initializing the swiper"
    #temporary shim to fix the issues with swiper not re
    #initializing when changing to a new lesson
    #leading to bugs when the lesson has more modules
    #than the first lesson (when the swiper was initialized)
    if newIndex == 1
      @swiper = App.swiper '.swiper-container', {
        lazyLoading: true,
        preloadImages: false,
        speed: 700,
        shortSwipes: false
        longSwipes: false
        followFinger: false
      }
    @displayModule( newIndex )

  @onNextButtonRendered = =>
    @swiper = App.swiper '.swiper-container', {
      lazyLoading: true,
      preloadImages: false,
      speed: 700,
      shortSwipes: false
      longSwipes: false
      followFinger: false
    }

  @isBonus = (module) =>
    lesson = @getLesson()
    lastModule = lesson?.modules?[lesson?.modules?.length - 1]
    return module.type == "VIDEO" and lastModule == module._id

  @onNextButtonClicked = =>
    #if @hasBonusVideo() and @secondToLastModule() then @offerBonusVideo()
    lessonComplete = @lessonComplete()
    if @lessonComplete() then @celebrateCompletion() else @goToNextModule()

  @nextButtonText = =>
    console.log "Translations"
    console.log TAPi18n
    console.log "GETing tlanguage #{TAPi18n.getLanguage()}"
    console.log TAPi18n._ "finish"
    console.log TAPi18n._ "next"
    if @lessonComplete() then TAPil8n._ "finish" else TAPil8n._ "next" + '<i class="fa fa-arrow-right fa-2x"></i>'

  @afterReplay = =>
    @state.set "replayAudio", false

  @onReplayButtonClicked = =>
    @state.set "replayAudio", true

  @shouldShowReplayButton = =>
    module = @getCurrentModule()
    return module?.type isnt "VIDEO"

  @onPlayVideo = =>
    @state.set "playingVideo", true

  @onStopVideo = =>
    @state.set "playingVideo", false

  @onVideoEnd = =>
    @state.set "playingVideo", false
    @state.set "nextButtonAnimated", true

  @videoPlaying = =>
    playing = @state.get "playingVideo"
    if playing? then return playing else return false

  @shouldPlayQuestionAudio = (id) =>
    isPlayingQuestion = @state.get "playingQuestion"
    return @isCurrent(id) and isPlayingQuestion

  @shouldPlayExplanationAudio = (id) =>
    shouldPlay = @state.get "playingExplanation"
    if @isCurrent(id) and shouldPlay then return true else return false

  @autorun =>
   if Meteor.isCordova and Meteor.status().connected
    @subscribe "curriculums.all"
    @subscribe "lessons.all"
    @subscribe "modules.all"

  @autorun =>
    if ContentInterface.subscriptionsReady(@)
      @setCurrentModuleId()

Template.Lesson_view_page.helpers
  modulesReady: ->
    instance = Template.instance()
    return ContentInterface.subscriptionsReady(instance)

  footerArgs: ->
    instance = Template.instance()
    return {
      homeButton: {
        onClick: instance.goHome
        shouldShow: -> return true
      }
      nextButton: {
        onClick: instance.onNextButtonClicked
        text: instance.nextButtonText()
        onRendered: instance.onNextButtonRendered
        animated: instance.state.get("nextButtonAnimated")
      }
      replayButton: {
        onClick: instance.onReplayButtonClicked
        shouldShow: instance.shouldShowReplayButton
      }
      pages: instance.getPagesForPaginator()
    }

  lessonTitle: ->
    instance = Template.instance()
    return instance.getLesson()?.title

  moduleArgs: (module) ->
    instance = Template.instance()
    isQuestion = (type) ->
      return type == "BINARY" or type == "SCENARIO" or type == "MULTIPLE_CHOICE"

    isCurrentModule = instance.isCurrent(module._id)
    if isQuestion module.type
      showAlert = if module.type == 'MULTIPLE_CHOICE' then false else true
      return {
        module: module
        incorrectClasses: instance.state.get "incorrectClasses"
        incorrectlySelectedClasses: instance.state.get "incorrectlySelectedClasses"
        correctlySelectedClasses: instance.state.get "correctlySelectedClasses"
        onCorrectChoice: instance.onChoice(instance, "CORRECT", showAlert)
        onWrongChoice: instance.onChoice(instance, "WRONG", showAlert)
        onCompletedQuestion: instance.onCompletedQuestion(instance)
      }
    else if module.type == "VIDEO"
      return {
        module: module
        onPlayVideo: instance.onPlayVideo
        onStopVideo: instance.onStopVideo
        onVideoEnd: instance.onVideoEnd
        playing: isCurrentModule and instance.videoPlaying()
      }
    else
      return {module: module}

  hasAudio: (module) ->
    return module.audio?

  hasExplanation: (module) ->
    return module.correct_audio?

  explanationArgs: (module) ->
    instance = Template.instance()
    playing = instance.state.get("audioPlaying") == "EXPLANATION"
    replay = instance.state.get("replayAudio")
    isCurrent = instance.isCurrent(module._id)
    return {
      attributes: {
        src: ContentInterface.getSrc module.correct_audio, "AUDIO"
      }
      playing: playing and isCurrent
      replay: playing and replay and isCurrent
      afterReplay: instance.afterReplay
      whenFinished: instance.onFinishExplanation
      whenPaused: instance.trackAudioStopped
    }

  audioArgs: (module) ->
    instance = Template.instance()
    playing = instance.state.get("audioPlaying") == "QUESTION"
    replay = instance.state.get("replayAudio")
    isCurrent = instance.isCurrent(module._id)
    return {
      attributes: {
        src: ContentInterface.getSrc module.audio, "AUDIO"
      }
      playing: playing and isCurrent
      replay: playing and replay and isCurrent
      afterReplay: instance.afterReplay
      whenFinished: instance.trackAudioStopped
      whenPaused: instance.trackAudioStopped
    }

  incorrectSoundEffectArgs: ->
    instance = Template.instance()
    playing = instance.state.get("soundEfffectPlaying") == "INCORRECT"
    return {
      attributes: {
        src: ContentInterface.getSrc(ContentInterface.incorrectSoundEffectFilename(), "AUDIO")
      }
      playing: playing
      whenFinished: instance.stopPlayingSoundEffect
      whenPaused: instance.stopPlayingSoundEffect
    }

  correctSoundEffectArgs: ->
    instance = Template.instance()
    playing = instance.state.get("soundEfffectPlaying") == "CORRECT"
    return {
      attributes: {
        src: ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO")
      }
      playing: playing
      whenFinished: instance.stopPlayingSoundEffect
      whenPaused: instance.stopPlayingSoundEffect
    }

  modules: ->
    instance = Template.instance()
    return instance.getModules()

  getTemplate: (module) ->
    if module?.type == "BINARY"
      return "Lesson_view_page_binary"
    if module?.type == "MULTIPLE_CHOICE"
      return "Lesson_view_page_multiple_choice"
    if module?.type == "SCENARIO"
      return "Lesson_view_page_scenario"
    if module?.type == "VIDEO"
      return "Lesson_view_page_video"
    if module?.type == "SLIDE"
      return "Lesson_view_page_slide"
