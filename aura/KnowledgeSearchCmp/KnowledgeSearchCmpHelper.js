({
    searchKBArticles: function(component, event, helper, searchTerm, selectedCategory1, selectedCategory2, selectedCategory3, selectedCategory4, callback) {
		debugger;
        
        var action = component.get('c.search');
  		action.setParams({'searchTerm': searchTerm,
                          'selectedCategory1': selectedCategory1,
                          'selectedCategory2': selectedCategory2,
                          'selectedCategory3': selectedCategory3,
                          'selectedCategory4': selectedCategory4});
  		action.setCallback(this, function(response) {
  			var state = response.getState();
  			if (component.isValid() && state==='SUCCESS') {
                debugger;
                var result = response.getReturnValue();
                if(result && callback) {
					callback(result);
                }
  			} else {
  			    this.handleActionError(component, response, function() {
                 	console.log('Error on calling getLocation: ' + response);                                                        
                });
     		}
  		})
  		$A.enqueueAction(action);
    },
    
	getDataCategoryGroups: function(component, event, helper, callback) {
		var action = component.get('c.getDataCategoryGroups');
  		action.setCallback(this, function(response) {
  			var state = response.getState();
  			if (component.isValid() && state==='SUCCESS') {
                var result = response.getReturnValue();
                if(result && callback) {
				    callback(result);
                }    
  			} else {
  			    helper.handleActionError(component, response, function(){
                });
     		}
  		})
  		$A.enqueueAction(action);
    },
    
    getRecentlyviewedArticles: function(component, event, helper, callback) {
		var action = component.get('c.getRecentViewedArticles');
  		action.setCallback(this, function(response) {
  			var state = response.getState();
  			if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();
                if(result && callback) {
				    callback(result);
                }    
  			} else {
  			    helper.handleActionError(component, response, function(){
                });
     		}
  		})
  		$A.enqueueAction(action);
    },

})