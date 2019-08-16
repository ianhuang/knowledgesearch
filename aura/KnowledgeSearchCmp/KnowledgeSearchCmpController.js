({
	doInit: function(component, event, helper) {
        helper.getDataCategoryGroups(component, event, helper, function(result) {
            component.set('v.dataCategoryGroups', result);
        });
        helper.getRecentlyviewedArticles(component, event, helper, function(result) {
            component.set('v.recentlyViewedArticles', result);
        });
    },
        
    searchKB: function(component, event, helper) {
        debugger;
        
        var topCategory = '';
        var category    = '';
        var searchTerm  = component.find('searchTerm').get('v.value');
        
        //if(searchTerm.length <= 3) {
        //    helper.showError(component, 'Search term must be longer than 3 characters: ' + searchTerm);
        //    return;
        //}
        
        helper.showSpinner(component);
        var selectedCategory1 = component.get('v.selectedCategory1');
        var selectedCategory2 = component.get('v.selectedCategory2');
        var selectedCategory3 = component.get('v.selectedCategory3');
        var selectedCategory4 = component.get('v.selectedCategory4');
        //if(selectedCategory != '') {
        //	topCategory = selectedCategory.split('|')[0];
        //	category    = selectedCategory.split('|')[1];
        //}
        
        helper.searchKBArticles(component, event, helper, searchTerm, selectedCategory1, selectedCategory2, selectedCategory3, selectedCategory4, function(result) {
            component.set('v.articles', result);
            helper.hideSpinner(component);
        });
    },
    
    navigate: function(component, event, helper) {
        var event = $A.get("e.force:navigateToSObject");
        event.setParams({
			"recordId": component.get('v.article').KnowledgeArticleId
		});
		event.fire();
    }

})