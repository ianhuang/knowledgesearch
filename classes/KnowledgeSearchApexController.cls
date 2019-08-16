// Description: Classic Knowledge article search component
// Test class: KnowledgeSearchApexControllerTest
public with sharing class KnowledgeSearchApexController {
    
    public class Selection {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}
        
        @AuraEnabled
        public List<Selection> childSelections {get; set;}
        
        public Selection(String label, String value) {
            this.label = label;
            this.value = value;
            this.childSelections = new List<Selection>();
        }
    }
    
    private static final String KNOWLEDGE_CATEGORY_OBJECT = 'KnowledgeArticleVersion';
    
    @AuraEnabled
    public static List<Selection> getDataCategoryGroups(){
       List<Selection> result = new List<Selection>();
           
       List<DescribeDataCategoryGroupResult> describeCategoryResult;
       List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
 
       try {
          //Creating the list of sobjects to use for the describe call
          List<String> objType = new List<String>();

          objType.add(KNOWLEDGE_CATEGORY_OBJECT);

          //Describe Call
          describeCategoryResult = Schema.describeDataCategoryGroups(objType);
          List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
 
          for(DescribeDataCategoryGroupResult singleResult : describeCategoryResult){
             DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
             p.setSobject(singleResult.getSobject());
             p.setDataCategoryGroupName(singleResult.getName());
             pairs.add(p);
          }
           
          describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);
 
 
          //Using the results and retrieving the information
          for(DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult) {
             singleResult.getName();
             singleResult.getLabel();
             
             Selection item = new Selection(singleResult.Label, singleResult.Name);
             
             //Get the top level categories
             DataCategory[] toplevelCategories = singleResult.getTopCategories();
             //Recursively get all the categories
             List<DataCategory> allCategories = getAllCategories(toplevelCategories);

             for(DataCategory category : allCategories) {
                category.getName();
                category.getLabel();
                 
                item.childSelections.add(new Selection(category.label, category.name)); 
                //Get the list of sub categories in the category
                DataCategory [] childCategories = category.getChildCategories();
             }
             
             //only add if it has more than 1 children 
             if(item.childSelections.size() > 1) 
                 result.add(item); 
          }         
       } catch(Exception ex){
           System.debug('Unexpected error: ' + ex.getMessage());
       }
      
       return result;
    }
    
    private static DataCategory[] getAllCategories(DataCategory[] categories){
        if(categories.isEmpty()){
            return new DataCategory[]{};
        } else {
            DataCategory [] categoriesClone = categories.clone();
            DataCategory category = categoriesClone[0];
            DataCategory[] allCategories = new DataCategory[]{category};
                
            categoriesClone.remove(0);
            categoriesClone.addAll(category.getChildCategories());
            allCategories.addAll(getAllCategories(categoriesClone));
            return allCategories;
        }
   }
    

    @AuraEnabled
    public static List<KnowledgeArticleVersion> search(String searchTerm, String selectedCategory1, String selectedCategory2, String selectedCategory3, String selectedCategory4) {
        if(String.isNotBlank(searchTerm)) {
            return searchSOSL(searchTerm, selectedCategory1, selectedCategory2, selectedCategory3, selectedCategory4);
        } else {
            return searchSOQL(selectedCategory1, selectedCategory2, selectedCategory3, selectedCategory4);
        }
    }
    
    private static List<KnowledgeArticleVersion> searchSOQL(String selectedCategory1, String selectedCategory2, String selectedCategory3, String selectedCategory4) {
        String online = 'online';
        String soql = 'SELECT Id,ArticleNumber,KnowledgeArticleId,LastPublishedDate,Title FROM KnowledgeArticleVersion WHERE PublishStatus=:online';
        
        selectedCategory1 = String.escapeSingleQuotes(selectedCategory1);
        selectedCategory2 = String.escapeSingleQuotes(selectedCategory2);
        selectedCategory3 = String.escapeSingleQuotes(selectedCategory3);
        selectedCategory4 = String.escapeSingleQuotes(selectedCategory4);
        
        if(String.isNotBlank(selectedCategory1))
            soql += ' WITH DATA CATEGORY ' + selectedCategory1.split('\\|')[0] + '__c BELOW ' + selectedCategory1.split('\\|')[1] + '__c';
        if(String.isNotBlank(selectedCategory2)) {
            if(soql.contains('WITH DATA CATEGORY'))
                soql += ' AND ';
            else
                soql += ' WITH DATA CATEGORY ';
            soql += selectedCategory2.split('\\|')[0] + '__c BELOW ' + selectedCategory2.split('\\|')[1] + '__c';
        }    
        if(String.isNotBlank(selectedCategory3)) {
            if(soql.contains('WITH DATA CATEGORY'))
                soql += ' AND ';
            else
                soql += ' WITH DATA CATEGORY ';
            soql += selectedCategory3.split('\\|')[0] + '__c BELOW ' + selectedCategory3.split('\\|')[1] + '__c';
        }
        if(String.isNotBlank(selectedCategory4)) {
            if(soql.contains('WITH DATA CATEGORY'))
                soql += ' AND ';
            else
                soql += ' WITH DATA CATEGORY ';
            soql += selectedCategory4.split('\\|')[0] + '__c BELOW ' + selectedCategory4.split('\\|')[1] + '__c';
        }
        System.debug('soql = ' + soql);

        // perform search
        List<KnowledgeArticleVersion> articles = Database.query(soql);

        return articles;
    }
    
    private static List<KnowledgeArticleVersion> searchSOSL(String searchTerm, String selectedCategory1, String selectedCategory2, String selectedCategory3, String selectedCategory4) {
        String online = 'online';
        String sosl = 'FIND {' + String.escapeSingleQuotes(searchTerm) + 
                      '} IN ALL FIELDS RETURNING KnowledgeArticleVersion(ArticleNumber,KnowledgeArticleId,LastPublishedDate,Title WHERE PublishStatus=:online)';
        
        selectedCategory1 = String.escapeSingleQuotes(selectedCategory1);
        selectedCategory2 = String.escapeSingleQuotes(selectedCategory2);
        selectedCategory3 = String.escapeSingleQuotes(selectedCategory3);
        selectedCategory4 = String.escapeSingleQuotes(selectedCategory4);
        
        if(String.isNotBlank(selectedCategory1))
            sosl += ' WITH DATA CATEGORY ' + selectedCategory1.split('\\|')[0] + '__c BELOW ' + selectedCategory1.split('\\|')[1] + '__c';
        if(String.isNotBlank(selectedCategory2)) {
            if(sosl.contains('WITH DATA CATEGORY'))
                sosl += ' AND ';
            else
                sosl += ' WITH DATA CATEGORY ';
            sosl += selectedCategory2.split('\\|')[0] + '__c BELOW ' + selectedCategory2.split('\\|')[1] + '__c';
        }    
        if(String.isNotBlank(selectedCategory3)) {
            if(sosl.contains('WITH DATA CATEGORY'))
                sosl += ' AND ';
            else
                sosl += ' WITH DATA CATEGORY ';
            sosl += selectedCategory3.split('\\|')[0] + '__c BELOW ' + selectedCategory3.split('\\|')[1] + '__c';
        }
        if(String.isNotBlank(selectedCategory4)) {
            if(sosl.contains('WITH DATA CATEGORY'))
                sosl += ' AND ';
            else
                sosl += ' WITH DATA CATEGORY ';
            sosl += selectedCategory4.split('\\|')[0] + '__c BELOW ' + selectedCategory4.split('\\|')[1] + '__c';
        }

        
        System.debug('sosl = ' + sosl);

        // perform search
        Search.SearchResults searchResults = Search.find(sosl);
        List<Search.SearchResult> articlelist = searchResults.get(KNOWLEDGE_CATEGORY_OBJECT);
        List<KnowledgeArticleVersion> articles = new List<KnowledgeArticleVersion>();
        for (Search.SearchResult searchResult : articleList) {
            KnowledgeArticleVersion article = (KnowledgeArticleVersion)searchResult.getSObject();
            articles.add(article);
        }
        return articles;
    }
    
    @AuraEnabled
    public static List<RecentlyViewed> getRecentViewedArticles() {
        Set<String> articleTypes = getArticleTypes();
        
        return  [SELECT   Id, Name, Type
                 FROM     RecentlyViewed
                 WHERE    LastViewedDate != null
                 AND      Type IN :articleTypes
                 ORDER BY LastViewedDate DESC
                 LIMIT 100];            
    }
    
    private static Set<String> getArticleTypes(){
        Set<String> result = new Set<String>();
        
        AggregateResult[] groupedResults = 
           [SELECT   ArticleType
            FROM     KnowledgeArticleVersion 
            WHERE    PublishStatus='Online'
            AND      Language ='en_US'
            GROUP BY ArticleType];

        for (AggregateResult ar : groupedResults)  {
            //replace __kav suffix with __ka
            result.add(String.valueOf(ar.get('ArticleType')).replace('__kav', '__ka'));
        }
        
        return result;
    }
        
}