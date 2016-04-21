
ContentInterface = require('../../api/content/ContentInterface.coffee').ContentInterface
ContentDownloader = require('../../api/cordova/ContentDownloader.coffee').ContentDownloader

Curriculums = require('../../api/curriculums/curriculums.coffee').Curriculums

AppState = require('../../api/AppState.coffee').AppState

# TEMPLATE
require './home.html'

# COMPONENTS
require '../../ui/components/navbar.html'
require '../../ui/components/home/footer.html'
require '../../ui/components/home/thumbnail.coffee'
require '../../ui/components/home/menu/menu.coffee'
require '../../ui/components/home/menu/list_item.coffee'
require '../../ui/components/audio/audio.coffee'

Template.Home_page.onCreated ->
  @getLessonDocuments = =>
    curriculum = @getCurriculumDoc()
    docs = curriculum?.getLessonDocuments()
    return docs

  @getCurriculumDoc = =>
    id = AppState.get().getCurriculumId()
    return Curriculums?.findOne {_id: id }

  @currentLessonId = =>
    curriculum = @getCurriculumDoc()
    lessonIndex = AppState.get().getLessonIndex()
    return curriculum?.lessons?[lessonIndex]

  @onLessonSelected = (id) ->
    FlowRouter.go "lesson", {_id: id}

  @onCurriculumSelected = ( id ) ->
    AppState.get().setCurriculumId id
    if Meteor.isCordova
      AppState.get().setCurriculumDownloaded false

  @autorun =>
    id = AppState.get().getCurriculumId()
    @subscribe "curriculums.all"
    if Meteor.isCordova
      @subscribe "lessons.all"
      @subscribe "modules.all"
    else
      @subscribe "lessons.inCurriculum", id

  @autorun =>
    subscriptionsReady = @subscriptionsReady()
    id = AppState.get().getCurriculumId()
    curriculumDownloaded = AppState.get().getCurriculumDownloaded(id)
    if subscriptionsReady and Meteor.isCordova and id? and not curriculumDownloaded
      onError = (e) ->
        console.log "ERROR LOADING"
        console.log e
      onSuccess = (e) ->
        console.log "SUCCESS LOADING"
        AppState.get().setCurriculumDownloaded true
      ContentDownloader.get().loadCurriculum id, onSuccess, onError


Template.Home_page.helpers
  curriculumsReady: ->
    instance = Template.instance()
    curriculumDownloaded = if Meteor.isCordova then AppState.get().getCurriculumDownloaded() else true
    return instance.subscriptionsReady() and curriculumDownloaded

  menuArgs: ->
    instance = Template.instance()
    curriculumsToList = Curriculums.find({title:{$ne: "Start a New Curriculum"}})
    return {
      onCurriculumSelected: instance.onCurriculumSelected
      curriculums: curriculumsToList
    }

  thumbnailArgs: (lesson) ->
    instance = Template.instance()
    isCurrentLesson = ( lesson?._id == instance.currentLessonId() )
    return {
      lesson: lesson
      onLessonSelected: instance.onLessonSelected
      isCurrentLesson: isCurrentLesson
    }

  audioArgs: ->
    instance = Template.instance()
    setPlayIntroToFalse = -> AppState.get().setShouldPlayIntro false
    return {
      attributes: {
        src: ContentInterface.get().introAudio()
      }
      playing: AppState.get().getShouldPlayIntro()
      whenPaused: setPlayIntroToFalse
      whenFinished: setPlayIntroToFalse
    }

  lessons: ->
    instance = Template.instance()
    return instance.getLessonDocuments()
