'use strict';

var _ = require('lodash');
var request = require('request');
var config = require('../../config/environment');
var ch = require('cheerio');

// Get list of alls
exports.index = function(req, res) {
  var categories = [];
  request(config.marktplaats + '/', function (err, resp, body) {
    var $ = ch.load(body);
    $('ul#navigation-categories a').each(function (i, link) {
      link = $(link);
      var url = link.attr('href');
      //extract the ID from the URL: last bit including .html has the id, like 'c31.html',
      //so we split on the '/' separator, take the last item, split it on '.', and remove 'c'
      //to be left with the ID number
      var id = url.split('/').pop().split('.').shift().substr(1);
      categories.push({
        name: link.html(),
        id: id,
        url: url
      });
    })
    return res.json(categories);
  });
};
