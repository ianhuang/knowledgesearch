@isTest
private class KnowledgeSearchApexControllerTest {
	
    @isTest
    static void testSearch() {
        FAQ__kav article= new FAQ__kav(Title='UnitTest FAQ 101', Summary='Summary', UrlName='TestFAQ101');
        insert article;
        article = [SELECT KnowledgeArticleId FROM FAQ__kav WHERE Id = :article.Id];
        //publish KB
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);
        
        Test.startTest();
        List<KnowledgeArticleVersion> articles = KnowledgeSearchApexController.search('UnitTest', '', '', '', '');
        System.assertEquals(0, articles.size());
        Test.stopTest();
    }
        
    @isTest
    static void testRecentViewed() {
        List<RecentlyViewed> articles = KnowledgeSearchApexController.getRecentViewedArticles();
        System.assertEquals(0, articles.size());
    }
    
}