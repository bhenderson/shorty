# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

load_g_charts = ->

  drawChart = ->
    options = {
      title: 'URL Performance',
      curveType: 'function',
      legend: { position: 'bottom' }
    }

    chart = new google.visualization.LineChart document.getElementById 'chart'

    query = new URLSearchParams(location.search)
    code = query.get "code"
    unless code
      return

    opts = {
      type: "GET",
      url: "/stats/"+code,
      success: (resp) ->
        return unless resp.length
        data = new google.visualization.DataTable()
        data.addColumn "datetime", "Time"
        data.addColumn "number", "Hits"
        data.addRows( [new Date(stat.created_at), i] for stat, i in resp )

        chart.draw data, options
    }
    $.ajax opts

  google.charts.load 'current', {packages: ['corechart']}
  google.charts.setOnLoadCallback drawChart

$(document).on "turbolinks:load", ->
  load_g_charts()
