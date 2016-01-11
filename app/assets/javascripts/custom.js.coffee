ready = ->
  input = $(".team-users-autocomplete")
  teamUsers = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace("value")
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote: 
      url: input.data('url') + '?query='
      replace: (url, query) ->
      # $('.tt-hint').css 'background-image', 'url("/assets/svg/auto-complete-spinner.svg")'
      # $('.tt-hint').css 'background-repeat', 'no-repeat'
      # $('.tt-hint').css 'top', '6px'
      # $('.tt-hint').css 'left', '6px'
      # $('.tt-hint').css 'width', '22px'
      # $('.tt-hint').css 'height', '22px'
      # $('.new_team i.ec-user.left-input-icons').addClass('hidden')
        url + encodeURIComponent(query)
      filter: (parsedResponse) ->
        # $('.tt-hint').css 'background-image', ''
        # $('.new_team i.ec-user.left-input-icons').removeClass('hidden')
        parsedResponse
  )
  teamUsers.initialize()
  input.typeahead highlight: true,
    name: "users"
    displayKey: "nom"
    limit: 999
    source: teamUsers.ttAdapter()
    templates:
      empty: 'Aucun résultat'
      suggestion: (el) ->
        '<a href = "/users/'+el.id+'" class="col-sm-12"><div style="float:left; width:50px;"><img src="'+el.picture_url+'" style="height:50px;width:50px;float:left; " /></div><div style="float:right; width: 220px;">' + el.prenom + el.nom + el.maiden_name + '<h5>Promo ' + el.promo + '</h5></div></a>'

$(document).ready ready