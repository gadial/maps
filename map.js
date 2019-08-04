$(document).ready(function(){
    $(".state").click(function(e) {
        console.log("Hi I'm over state", e.target.id);
    });

    panZoomInstance = svgPanZoom('#fantasyMap', {
        zoomEnabled: true,
        controlIconsEnabled: true,
        fit: true,
        center: true,
        minZoom: 0.1
      });
      
      // zoom out
      panZoomInstance.zoom(1)
});