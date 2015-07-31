'use strict';

var _ = require('lodash');
var querystring = require('querystring');
var config = require('../../config/environment');
var ch = require('cheerio');
var Promise = require('bluebird');
var request = Promise.promisify(require('request'));
Promise.promisifyAll(request);

var adsFromHtml = function (html) {
  console.info(html);
  var $ = ch.load(html);
  var results = [];
  var allAds = $('article.search-result').not('.listing-cas').each(function (i, ad) {
    ad = $(ad);
    var img = $(ad.find('figure img')[0]);
    results.push({
      url: $(ad.find('.heading a')[0]).attr('href'),
      img: 'http:'+img.attr('src'),
      title: img.attr('title'),
      price: $(ad.find('.price-new')[0]).text()
    });
  });
  return results;
}

// Get list of searchs
exports.index = function(req, res) {
  var categories = req.param('categories');
  var zipcode = req.param('zipcode');
  var term = req.param('term');
  var distance = req.param('distance') || 0;
  var priceFrom = req.param('from') || "0,00";
  var priceTo = req.param('to') || "0,00";
  var opts = {
    query: term,
    postcode: zipcode,
    distance: distance,
    sortBy: "SortIndex",
    sortOrder: "decreasing", //newest first
    priceFrom: priceFrom,
    priceTo: priceTo
  }

  Promise.map(categories, function (cat) {
    opts.categoryId = cat;
    //in each category, find the results from marktplaats
    var url = config.marktplaats + '/z.html?' + querystring.stringify(opts);
    console.info(url);
    return request(url)
    .then(function (resp) {
      return adsFromHtml(resp[0].body);
    });
  })
  .then(function (results) {
    console.info(results);
    return res.json(results);
  });
};
