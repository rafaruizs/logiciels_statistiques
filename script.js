<div id="tooltip" class="hidden">
	<p><strong><span id="agglo">Agglomeration</span></strong></p>
	<p id="det">Details</p>
</div>

<script src="http://d3js.org/d3.v3.js" charset="utf-8"></script>
<script>

  var width = 600, height = 500;
  var color = d3.scale.quantize()
                .range(["rgb(237,248,233)", "rgb(186,228,179)",
                 "rgb(116,196,118)", "rgb(49,163,84)","rgb(0,109,44)"])
                .domain([0, 100]);
                

  var networkOutputBinding = new Shiny.OutputBinding();
  
  $.extend(networkOutputBinding, {
    find: function(scope) {
      return $(scope).find('.montreal-map-output');
    },
    
    renderValue: function(el, data) {
      
        //console.log(cols)
        console.log(data)
        
        var agglos = null;
        var agglo_col_name = data.colAgglo; //"Agglomeration";
        
        if ((data != null) && (agglo_col_name != '')) {
          agglos = data[agglo_col_name];
        }
        
        var getSelectedVarList = function(dt, agglo_col_name)
        {
          var list = [];
          
          for(v in dt) {
            if (v.match(/^cols[0-9]*$/)) {
              //out += v + ': ' + dt[v][current_agglo] + '<br/>';
              vname = dt[v];
              if (vname != agglo_col_name) {
                list.push(vname);
              }
            }
          }
          
          return list;
        };
        
        var setNormalColor = function(d)
        {
          
          var vars = getSelectedVarList(data, agglo_col_name);
          console.log(vars);
          
          var agglo = d.properties.ABREV;
          if (value) {
              return color(value);
          } else {
              return "red";
          }
        };

        d3.select("div.montreal-map-output svg").remove();
        var svg = d3.select("div.montreal-map-output").append("svg")
                    .attr("width", width)
                    .attr("height", height);
                    
        if (svg != null) {   
          
            d3.json("geo.json", function(error, nyb) {
              
              
              var projection = d3.geo.mercator()
        				.center([-73.94, 45.70])
      					.scale(50000)
      					.translate([(width) / 10, (height)/10]);
    
            	var path = d3.geo.path()
            			.projection(projection);
            
            	var g = svg.append("g"), current_agglo = null;
            
            	g.append("g")
            		.attr("id", "boroughs")
            		.selectAll("path")
            		.data(nyb.features)
            		.enter().append("path")
            		//.attr("class", function(d){ return d.properties.name; })
            		.attr("d", path)
            		//.style("fill", "white")
                .style("fill", setNormalColor)
            		.style("stroke", "rgb(0,109,44)")
            		.on("mouseover", function(d) {
                  
                  if (agglos == null) return;
                  
                  current_agglo = agglos.indexOf(d.properties.ABREV);
                  
            			d3.select(this).style("fill", "orange");
            			var coordinates = [0, 0];
            			coordinates = d3.mouse(this);
            			var target = d3.select("#tooltip")
            							.style("left", coordinates[0] + "px")
            							.style("top", coordinates[1]-50 + "px");
                  
                  // on recupere les variables selectionnees
                  var out = '', vname = null, val = null;
                  var vars = getSelectedVarList(data, agglo_col_name);
                  for(vname in vars) {
                    val = data[vars[vname]][current_agglo];
                    out += vars[vname] + ': ' + val + '<br/>';
                  }

                  /*
                  for(v in data) {
                    if (v.match(/^cols[0-9]*$/)) {
                      //out += v + ': ' + data[v][current_agglo] + '<br/>';
                      vname = data[v];
                      if (vname != agglo_col_name) {
                        val = data[vname][current_agglo];
                        out += vname + ': ' + val + '<br/>';
                      }
                    }
                  }
                  */
            
            			target.select("#agglo").text(d.properties.NOM);
            			target.select("#det").html(out);
            			d3.select("#tooltip").classed("hidden", false);
            
            		})
            		.on("mouseout", function(d) {
            			d3.select(this)
                    //.style("fill", "white")
                    .style("fill", setNormalColor(d));
            			d3.select("#tooltip").classed("hidden", true);
            		})
            		;
              
              
              
            });
        
        }
        
    }
  });
  
  Shiny.outputBindings.register(networkOutputBinding, 'mtl.app');
  
</script>