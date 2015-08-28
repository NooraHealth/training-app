

###
# Binary Choice Surface
###
class @BinarySurface extends ModuleSurface
  constructor: ( @module, index )->
    super @.module, index

    @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .8, 1, 1

    @.image = new ModuleImage(@.module)
    @.noBtn = new NoButton()
    @.yesBtn = new YesButton()

    @.addChild @.image
    @.addChild @.noBtn
    @.addChild @.yesBtn

class ModuleImage extends Node
  constructor: (@module)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .4, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, .8

    img = Scene.get().getContentSrc() + @.module.image
    @.domElement = new DOMElement @, {
      content: "<img src='#{img}' class='binary-image'></img>"
    }

class YesButton extends Node
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign .05, 1, .5
     .setMountPoint 0, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     .setProportionalSize .4, .2

    @.domElement = new DOMElement @, {
      content: "<a class='full-width btn green waves-light waves-effect white-text'>YES</a>"
    }

class NoButton extends Node
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign .95, 1, .5
     .setMountPoint 1, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     .setProportionalSize .4, .2

    @.domElement = new DOMElement @, {
      content: "<a class='full-width btn red waves-light waves-effect white-text'>NO</a>"
    }
