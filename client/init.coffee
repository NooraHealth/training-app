Meteor.startup ()->
  console.log "Subscribing to all"
  Meteor.subscribe "users"
  Meteor.subscribe "all_curriculums"
  Meteor.subscribe "all_modules"
  Meteor.subscribe "all_lessons"

  if Meteor.isCordova
    this.initializeServer()
