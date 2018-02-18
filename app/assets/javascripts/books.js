// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('DOMContentLoaded', function(){
  addGenre = function(event){
    event.preventDefault();

    var genres = document.getElementsByClassName('genre-title');
    var lastGenre = genres[genres.length - 1];
    var newGenre = lastGenre.cloneNode(true);
    var id = newGenre.name.match(/\d+/)[0];

    newGenre.name = newGenre.name.replace(/\[\d+\]/g, '[' + (parseInt(id) + 1) + ']');
    newGenre.id = newGenre.id.replace(/\d+/g, (parseInt(id) + 1));
    newGenre.value = '';
    document.getElementById('genres').appendChild(newGenre);
  };

  var addGenreButton = document.getElementById('add-genre');
  if(addGenreButton){
    addGenreButton.addEventListener('click', addGenre);
  }
});
