express = require "express"
request = require "request"
encoding = require "encoding"
router = express.Router()

router.get "/*", (req, res) ->
  if req.params[0].match /http/
    request "http://www.flvcd.com/parse.php?kw=#{req.params[0]}%26flag%3Done%26format%3Dsuper", (error, response, body) ->
      if not error and response.statusCode is 200
        body = encoding.convert(body, "GBK").toString()
        alllinks = body.match /href=".+".+onclick/g
        if alllinks
          vedioUrls = []
          for links in alllinks
            vedioUrls.push links.match(/"(.+?)"/)[1]

          res.render "index",
            title: "NoAD"
            vedio: vedioUrls.length + ",'" + vedioUrls.toString().replace(",","|") + "'"
        else
          res.status  404
          res.render "error",
              message: "Not Found"
              error: "404"
      else
        res.status  500
        res.render "error",
          message: "Net error"
          error: "500"
  else
    res.status  404
    res.render "error",
      message: "Not Found"
      error: "404"
module.exports = router