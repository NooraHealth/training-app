
Template.layout.helpers
  lessonTitle: ()->
    return Scene.get().getCurrentLesson().title

  module: ()->
    return FlowRouter.getParam "_id"

Template.layout.events
  "click #logo": ()->
    FlowRouter.go "/"