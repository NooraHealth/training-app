###
# Lesson
#
# A lesson is a collection of modules, and may or 
# may not contain sublessons
###

LessonSchema = new SimpleSchema
  short_title:
    type: String
    optional: true
  title:
    type:String
  description:
    type:String
    optional:true
  image:
    type: String
    regEx:  /^([/]?\w+)+[.]png/
  tags:
    type:[String]
    minCount:0
    optional:true
  has_sublessons:
    type:String
    defaultValue: "false"
  lessons:
    type:[String]
    optional:true
    custom: ()->
      if this.field('has_sublessons').value == "true"
        return "required"
  first_module:
    type:String
    optional:true
    custom: ()->
      if this.field('has_sublessons').value == "true"
        return "required"
  nh_id:
    type:String
    min:0

Lessons.attachSchema LessonSchema




