/*
 *
 * Thank you to Nate Strauser for his example
 * meteor-offline-files-demo
 */

//Files = new Ground.Collection('files');
//OfflineFiles = new Ground.Collection('offlineFiles', { connection: null });
var httpUrl = null;
var httpd = null;

this.initializeServer = function() {
  console.log("INITIALIZING SERVER");
  this.startServer = function(wwwroot) {
    console.log('starting server at ' + wwwroot);
    console.log("Is there httpd?"+ httpd);
    console.log(httpd);
    if (httpd) {
        //check whether server is already running
      httpd.getURL(function(url) {
        if (url.length > 0) {
          httpUrl = url;
          console.log("server is up: <a href='" + url + "' target='_blank'>" + url + "</a>");
        } else {

          httpd.startServer({
            'www_root': wwwroot,
            'port': 8080,
            'localhost_only': true
          }, function(url) {
            httpUrl = url;
              //if server is up, it will return the url of http://<server ip>:port/
              //the ip is the active network connection
              //if no wifi or no cell, "127.0.0.1" will be returned.
            console.log("server is started: <a href='" + url + "' target='_blank'>" + url + "</a>");
              //httpd.getLocalPath(function(path) {
                //console.log("localPath: " + path);
              //});

          }, function(error) {
            console.log('failed to start server: ' + error);
          });
        }

      });
    } else {
      console.log('CorHttpd plugin not available/ready.');
    }
  };

  httpd = (cordova && cordova.plugins && cordova.plugins.CorHttpd) ? cordova.plugins.CorHttpd : null;
  console.log("Initializing the server");
  if (httpd) {
    window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, function(fileSystem) {
      console.log('fileSystem');
      console.log(fileSystem);
      var path = fileSystem.root.nativeURL.replace("file://", "");
      console.log(path);
      this.startServer(path);
    });
  }
};


  //Session.setDefault('fileId', null);

  //Template.files.helpers({
    //files: function() {
      //return Files.find();
    //},
    //downloaded: function() {
      //return OfflineFiles.findOne({
        //fileId: this._id
      //});
    //},
    //connected: function () {
      //return Meteor.status().connected;
    //},
    //canLoad: function () {
      //return Meteor.status().connected || OfflineFiles.findOne({
        //fileId: this._id
      //});
    //}
  //});


  //Template.files.events({
    //'click .load': function(event, template) {
      //Session.set('fileId', this._id);
      ////console.log('setting file id ' + this._id);
      //Tracker.flush();

      //var sourceUrl = this.url;
      //var offlineFile = OfflineFiles.findOne({
        //fileId: this._id
      //});
      //if (offlineFile)
        //sourceUrl = httpUrl + offlineFile._id + "-" + offlineFile.fileName;

      //if(this.type === "video"){
        //$("#video-source").attr("src", sourceUrl);
        //$("#video").get(0).load();
      //}else if(this.type === "audio"){
        //$("#audio-source").attr("src", sourceUrl);
        //$("#audio").get(0).load();
      //}
    //},
    //'click .download': function(event, template) {
      //if (!OfflineFiles.findOne({
        //fileId: this._id
      //})) {
        //var file = this;
        ////console.log(file);
        //window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, function(fileSystem) {
          //var fileTransfer = new FileTransfer();
          //var offlineId = Random.id();
          ////console.log(fileSystem.root);
          //var path = fileSystem.root.toURL() + offlineId + "-" + file.fileName;
          //fileTransfer.download(
            //file.url,
            //path,
            //function(entry) {
              //// console.log("Success " + path);
              //// console.log(entry);
              //OfflineFiles.insert({
                //_id: offlineId,
                //fileId: file._id,
                //name: file.name,
                //fileName: file.fileName,
                //type: file.type,
                //fsPath: path
              //});
              ////console.log(OfflineFiles.findOne(offlineId));
            //},
            //function(error) {
              //console.log("Error during download. Code = " + error.code);
            //}
          //);
        //});

      //} else {
        //console.log('file already downloaded');
      //}

    //},
    //'click .delete': function(event, template) {
      //var offlineFile = OfflineFiles.findOne({
        //fileId: this._id
      //})
      //if (offlineFile) {
        //OfflineFiles.remove({
          //_id: offlineFile._id
        //});
      //}
    //}
  //});

  //Template.player.helpers({
    //file: function() {
      //if (!Session.equals('fileId', null))
        //return OfflineFiles.findOne({
          //fileId: Session.get('fileId')
        //}) || Files.findOne({
          //_id: Session.get('fileId')
        //});
    //},
    //fileUrl: function() {
      //var file = Files.findOne({
        //_id: Session.get('fileId')
      //});
      //var sourceUrl = file.url;
      //var offlineFile = OfflineFiles.findOne({
        //fileId: file._id
      //});
      //if (offlineFile)
        //sourceUrl = httpUrl + offlineFile._id + "-" + offlineFile.fileName;

      ////console.log('source url is ' + sourceUrl);
      //return sourceUrl;
    //}
  //});
//}

//if (Meteor.isServer) {
  //Meteor.startup(function() {
    //// code to run on server at startup

    //if (Files.find().count() === 0) {
      //console.log('loading sample Files');
      //Files.insert({
        //name: "lego",
        //fileName: "lego.mp4",
        //type:"video",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/video/lego.mp4"
      //});
      //Files.insert({
        //name: "construction",
        //fileName: "construction.mp4",
        //type:"video",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/video/construction.mp4"
      //});
      //Files.insert({
        //name: "water",
        //fileName: "water.mp4",
        //type:"video",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/video/water.mp4"
      //});


      //Files.insert({
        //name: "drop",
        //type:"image",
        //fileName: "drop.jpeg",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/image/drop.jpeg"
      //});
      //Files.insert({
        //name: "pop",
        //type:"image",
        //fileName: "pop.jpeg",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/image/pop.jpeg"
      //});
      //Files.insert({
        //name: "rock",
        //type:"image",
        //fileName: "rock.jpeg",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/image/rock.jpeg"
      //});
      //Files.insert({
        //name: "swirl",
        //type:"image",
        //fileName: "swirl.jpg",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/image/swirl.jpg"
      //});



      //Files.insert({
        //name: "cairnomount",
        //type:"audio",
        //fileName: "cairnomount.mp3",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/audio/cairnomount.mp3"
      //});
      //Files.insert({
        //name: "pipers_hut",
        //type:"audio",
        //fileName: "pipers_hut.mp3",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/audio/pipers_hut.mp3"
      //});
      //Files.insert({
        //name: "saewill",
        //type:"audio",
        //fileName: "saewill.mp3",
        //url: "https://dl.dropboxusercontent.com/u/1824773/offline/audio/saewill.mp3"
      //});


    //}
  //});
//}