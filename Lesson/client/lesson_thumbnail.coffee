Template.lessonThumbnail.helpers
  imageURL: ()->
    if _.isEmpty(@)
      return ""
    else
      return MEDIA_URL+ @.image
    
Template.lessonThumbnail.events
  'click .lesson-panel':(event, template)->
    console.log "adding class"
    event.preventDefault()

    $(".cd-panel").addClass 'is-visible'




