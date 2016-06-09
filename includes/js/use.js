// Sets the use.js configuration for your application
use = {
  jquery: {
    attach: "$" //attach jquery to window object
  },

  backbone: {
    deps: ["use!underscore", "use!jquery"],
    attach: "Backbone"  //attaches "Backbone" to the window object
  },

  underscore: {
    attach: "_" //attaches "_" to the window object
  }

} // end Use.js Configuration