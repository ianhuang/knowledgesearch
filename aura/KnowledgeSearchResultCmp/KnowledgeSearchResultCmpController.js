({
	navigate: function(component, event, helper) {
        var evt = $A.get("e.force:navigateToSObject");
        evt.setParams({
			"recordId": component.get('v.article').KnowledgeArticleId
		});
		evt.fire();
    }
})