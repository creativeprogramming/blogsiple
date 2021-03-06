{Schema} = require 'jugglingdb'

exports.getModels = (schema, otherModels) ->
  models = {}

  models.Blog = schema.define 'Blog',
    title:
      type: String
      length: 255
    description:
      type: String
      length: 255

  models.Blog.validatesUniquenessOf 'title'

  models.Post = schema.define 'Post',
    uuid:
      type: String
      length: 255
      index: true
    title:
      type: String
      length: 255
      index: true
    content:
      type: Schema.Text
    published:
      type: Boolean
      default: false
    published_at:
      type: Date
    created_at:
      type: Date

  models.Blog.hasMany models.Post,
    as: 'posts'
    foreignKey: 'blogId'

  models.Post.belongsTo models.Blog,
    as: 'blog'
    foreignKey: 'blogId'

  models.Post.afterCreate = (next) ->
    unless @created_at
      @updateAttribute 'created_at', new Date, ->
    do next

  models
