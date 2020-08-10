_ = require 'underscore'
{ parse } = require 'url'
Backbone = require 'backbone'
sd = require('sharify').data
Items = require '../../collections/items'
{ client } = require '../../lib/cache'
metaphysics = require '../../../lib/metaphysics2.coffee'
viewHelpers = require './view_helpers.coffee'
welcomeHero = require './welcome'
browseCategories = require './browse_categories.coffee'
query = require './queries/initial'
CurrentUser = require '../../models/current_user.coffee'

positionWelcomeHeroMethod = (req, res) ->
  method = if req.cookies?['hide-welcome-hero']? then 'push' else 'unshift'
  res.cookie 'hide-welcome-hero', '1', expires: new Date(Date.now() + 31536000000)
  method

fetchMetaphysicsData = (req, showHeroUnits, showCollectionsHubs)->
  new Promise((resolve) ->
    metaphysics(query: query, req: req, variables: {showHeroUnits: showHeroUnits, showCollectionsHubs: showCollectionsHubs})
      .then (data) -> resolve data
      .catch (err) ->
        resolve
          home_page:
            artwork_modules: []
            hero_units: err.data.home_page.hero_units
  )

@index = (req, res, next) ->
  try
    console.log('r1', Date.now())
    return if metaphysics.debug req, res, { method: 'post', query: query }

    # homepage:featured-sections
    featuredLinks = new Items [], id: '529939e2275b245e290004a0', item_type: 'FeaturedLink'

    jsonLD = {
      "@context": "http://schema.org",
      "@type": "WebSite",
      "url": "https://www.artsy.net/",
      "potentialAction": {
        "@type": "SearchAction",
        "target": "https://www.artsy.net/search?q={search_term_string}",
        "query-input": "required name=search_term_string"
      }
    }

    showCollectionsHubs = !res.locals.sd.CURRENT_USER
    res.locals.sd.PAGE_TYPE = 'home'
    console.log('r2', Date.now())

    # res.writeHead(200, {'content-type': 'text/html'})
    # res.setHeader('Content-Type', 'text/html');

    res.render('index1', {
      viewHelpers: viewHelpers
      browseCategories: browseCategories
    }, (err, html) =>
      try
        headerHtml = html.substring(0, html.length - 14)
        full = res.write headerHtml, 'utf8'
        initialFetch = Promise
          .allSettled([
            fetchMetaphysicsData req, true, showCollectionsHubs
            featuredLinks.fetch cache: true
          ]).then (results) =>
            try
              console.log('r3', Date.now())
              homePage = results?[0].value.home_page
              collectionsHubs = results?[0].value.marketingHubCollections
              heroUnits = homePage.hero_units

              # heroUnits[positionWelcomeHeroMethod(req, res)](welcomeHero) unless req.user?

              res.locals.sd.HERO_UNITS = heroUnits
              res.locals.sd.USER_HOME_PAGE = homePage.artwork_modules

              # for pasing data to client side forgot code
              res.locals.sd.RESET_PASSWORD_REDIRECT_TO = req.query.reset_password_redirect_to
              res.locals.sd.SET_PASSWORD = req.query.set_password
              console.log('r4', Date.now())

              res.render('index2', {
                heroUnits: heroUnits
                modules: homePage.artwork_modules
                featuredLinks: featuredLinks
                viewHelpers: viewHelpers
                browseCategories: browseCategories
                jsonLD: JSON.stringify jsonLD
                collectionsHubs: collectionsHubs
              }, (err, asyncHtml) =>
                try
                  res.end (asyncHtml + '</body></html>'), 'utf8'
                catch err
                  console.log(err)
                  next
              )
            catch err
              console.log(err)
              next
          .catch next
        console.log('f', full)
      catch err
        console.log(err)
        next
    )
  catch err
    console.log(err)
    next
