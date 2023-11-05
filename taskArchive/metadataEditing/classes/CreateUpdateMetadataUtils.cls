public with sharing class CreateUpdateMetadataUtils implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(' success : '+ result);
        } else {
            System.debug(' fail : '+ result);
        }
    }

    @AuraEnabled
    public static void createMetadata(String metadataText, String label) {
        try {
            system.debug('efsefsef');
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            Metadata.CustomMetadata metadataInstance =  new Metadata.CustomMetadata();

            metadataInstance.fullName = 'Settings__mdt.' + label;
            metadataInstance.label = label;

            Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
            customField1.field = 'metadata_Text__c';
            customField1.value = metadataText;
            metadataInstance.values.add(customField1);
                                  
            mdContainer.addMetadata(metadataInstance);

            CreateUpdateMetadataUtils callback = new CreateUpdateMetadataUtils();

            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);

        } catch(Exception ex){
            system.debug('Error while creating custom metadata.'+ex.getMessage());
        }
        
    }

}