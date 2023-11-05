public with sharing class metadataTableController  {

    @AuraEnabled
    public static void createMetadata(String metadataText, String label) {
        //return System.enqueueJob(new CreateUpdateMetadataUtils(metadataText, label));
    }


    // @AuraEnabled(cacheable=true)
    // public static list<Settings__mdt> getData(){
    //     return [SELECT id, MasterLabel, metadata_Text__c  FROM Settings__mdt];
    // }
}