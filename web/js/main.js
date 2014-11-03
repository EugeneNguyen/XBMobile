// Create cross browser requestAnimationFrame method:
window.requestAnimationFrame = window.requestAnimationFrame
 || window.mozRequestAnimationFrame
 || window.webkitRequestAnimationFrame
 || window.msRequestAnimationFrame
 || function(f){setTimeout(f, 1000/60);};

$(document).ready(function(){
  var intro_image = $('.intro_image');
  var intro_text = $('.intro_text');
  var usage_image = $('.usage_image');
  var usage_text = $('.usage_text');
  var logo = document.getElementById('logo');

  var plane = document.getElementById('plane');
  var building = document.getElementById('building');
  var cloud = document.getElementById('cloud');

  var window_width = parseInt($(window).width());
  var padding_screen = Math.ceil((window_width - 940)/2);
  var offset_intro_image = padding_screen + 310;
  var offset_usage_text = padding_screen + 400;
  var offset_intro_text = window_width - padding_screen - 420;
  var offset_usage_image = window_width - padding_screen - 550;

  var scrollheight = document.body.scrollHeight; // height of entire document
  var windowheight = window.innerHeight; // height of browser window

  function parallaxbubbles()
  {
   var scrolltop = window.pageYOffset; // get number of pixels document has scrolled vertically
   var scrollamount = (scrolltop / (scrollheight-windowheight)) * 100;

   if (scrolltop < 330)
   {
     // intro_image.css({
       // top: "0px",
       // left: -parseInt(offset_intro_image) + "px"
     // });
     intro_text.css({
       top: "0px",
       left: 420 + parseInt(offset_intro_text) + "px"
     });
   }

   if (scrolltop < 780)
   {
     usage_text.css({
       top: "363px",
       left: -parseInt(offset_usage_text) + "px"
     });
     // usage_image.css({
       // top: "363px",
       // left: 550 + parseInt(offset_usage_image) + "px"
     // });
   }

   if (scrolltop >= 330)
   {
     // intro_image.css({
       // top: "0px",
       // left: "0px"
     // });
     intro_text.css({
       top: "0px",
       left: "420px"
     });
   }

   if (scrolltop >= 780)
   {
     usage_text.css({
       top: "363px",
       left: "0px"
     });
     // usage_image.css({
       // top: "363px",
       // left: "550px"
     // });
   }

   if (scrolltop >= 0 && scrolltop < 120)
   {
     logo.style.top = 90 + scrolltop * 0.8 + "px";
     cloud.style.top = -scrolltop * 0.2 + "px";
     plane.style.top = -90 + scrolltop * 0.8 + "px";
   }
   else
   {
     // logo.style.top = 90 + scrolltop * 0.8 + "px";
     // cloud.style.top = -scrolltop * 0.2 + "px";
     // plane.style.top = -90 + scrolltop * 0.8 + "px";
     // building.style.top = scrolltop * 0.8 + "px";
   }

   // if (scrolltop > 210 && scrolltop < 600)
   // {
//
     // logo.style.top = 90 + scrolltop * 0.8 + "px";
     // building.style.top = (scrolltop-210) * 0.8 + "px";
     // plane.style.top = -90 + scrolltop * 0.8 + "px";
   // }

   // if (scrolltop > 0 && scrolltop < 550)
   // {
     // intro_image.style.left = -parseInt(offset_intro_image) + parseInt(scrolltop * intro_image_cst) + "px";
     // intro_text.style.left = 420 + parseInt(offset_intro_text) - scrolltop * intro_text_cst + "px";
     // usage_text.style.left = -parseInt(offset_usage_text) + parseInt(scrolltop * usage_text_cst) + "px";
     // usage_image.style.left = 550 + parseInt(offset_usage_image) - scrolltop * usage_image_cst + "px";
   // }
   // intro_image.css({
       // top: "0px",
       // left: -parseInt(offset_intro_image) + parseInt(scrolltop * intro_image_cst) + "px"
     // });
  }

  requestAnimationFrame(parallaxbubbles);
  window.addEventListener('scroll', function(){ // on page scroll
   requestAnimationFrame(parallaxbubbles); // call parallaxbubbles() on next available screen paint
  }, false);
});

