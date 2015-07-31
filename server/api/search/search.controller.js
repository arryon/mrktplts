'use strict';

var _ = require('lodash');
var querystring = require('querystring');
var config = require('../../config/environment');
var ch = require('cheerio');
var Promise = require('bluebird');
var request = Promise.promisify(require('request'));
Promise.promisifyAll(request);

var adsFromHtml = function (html) {
  var $ = ch.load(html);
  var results = [];
  var allAds = $('article.search-result').not('.listing-cas').each(function (i, ad) {
    ad = $(ad);
    var img = $(ad.find('figure img')[0]);
    var src = img.attr('src');
    var price = $(ad.find('.price-new')[0]).text();
    if (price !== '') {
      results.push({
        url: $(ad.find('.heading a')[0]).attr('href'),
        img: src.indexOf('http:') === 0 ? src : 'http:'+src,
        title: img.attr('title'),
        price: price
      });
    }
  });
  return results;
}

exports.index = function(req, res) {
  var category = req.param('category');
  var zipcode = req.param('zipcode');
  var term = req.param('term');
  var distance = req.param('distance') || 0;
  var priceFrom = req.param('priceFrom') || "0,00";
  var priceTo = req.param('priceTo') || "0,00";
  var opts = {
    query: term,
    postcode: zipcode,
    distance: distance,
    sortBy: "SortIndex",
    sortOrder: "decreasing", //newest first
    priceFrom: priceFrom,
    priceTo: priceTo,
    categoryId: category,
    numberOfResultsPerPage: "100"
  }

  //in each category, find the results from marktplaats
  var url = config.marktplaats + '/z.html?' + querystring.stringify(opts);
  console.info(url);
  request(url)
  .then(function (resp) {
    return res.json(adsFromHtml(resp[0].body));
  });
};
