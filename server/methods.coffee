Meteor.methods {
  contentEndpoint: ()->
    if process.env.METEOR_ENV == 'production'
      return "https://noorahealthcontent.s3-us-west-1.amazonaws.com/"
    else
      return 'https://noorahealth-development.s3-us-west-1.amazonaws.com/'

  isProduction: ()->
    return process.env.METEOR_ENV == 'production'

  getBucket: ()->
    if process.env.METEOR_ENV== 'production'
      return BUCKET
    else
      return DEV_BUCKET

  
}
