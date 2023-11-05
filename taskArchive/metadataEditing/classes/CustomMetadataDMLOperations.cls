/**
 * @description       : Perform DML operations on Custom metadata records
 * @author            : Shemetyuk Aleksey
 * @since             : 04-03-2021
**/
public with sharing class CustomMetadataDMLOperations {
    private MetadataServicePort.MetadataPort service;
    private MetadataService.CustomMetadata customMetadata;

    private List<String> apiRecordNamesForDelete {get; set;} {
        apiRecordNamesForDelete = new List<String>();
    }

    public CustomMetadataDMLOperations() {
        this.service = new MetadataServicePort.MetadataPort();
        this.service.SessionHeader = new MetadataServicePort.SessionHeader_element();
        this.service.SessionHeader.sessionId = MetadataUtils.getSessionId();
    }

    public CustomMetadataDMLOperations setCustomMetadata(String customMetadataApiName, String label){
        this.customMetadata = new MetadataService.CustomMetadata();
        this.customMetadata.fullName = customMetadataApiName;
        this.customMetadata.label = label;
        this.customMetadata.values = new List<MetadataService.CustomMetadataValue>();
        return this;
    }

    public CustomMetadataDMLOperations addCustomMetadataValue(String fieldApiName, String value){
        MetadataService.CustomMetadataValue field = new MetadataService.CustomMetadataValue();
        field.field = fieldApiName;
        field.value = value;
        this.customMetadata.values.add(field);
        return this;
    }

    public CustomMetadataDMLOperations setApiRecordNamesForDelete(List<String> apiNames){
        this.apiRecordNamesForDelete = apiNames;
        return this;
    }

    public void updateEndpointMetadataRecord() {
        List<MetadataServicePort.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { customMetadata });

        handleSaveResults(results[0]);
    }

    public void createEndpointMetadataRecord() {
        List<MetadataServicePort.SaveResult> results = service.createMetadata(new MetadataService.Metadata[] { customMetadata });

        handleSaveResults(results[0]);
    }

    public void deleteCustomMetadataRecords() {
        this.service.deleteMetadata('CustomMetadata', apiRecordNamesForDelete);
    }

    public void handleSaveResults(MetadataServicePort.SaveResult saveResult) {
        if (saveResult == null || saveResult.success) {
            return;
        }
        if (saveResult.errors != null) {
            List<String> messages = new List<String>();
            messages.add((saveResult.errors.size() == 1 ? 'Error ' : 'Errors ') + 'occured processing component ' + saveResult.fullName + '.');
            for (MetadataServicePort.Error error : saveResult.errors) {
                messages.add(error.message + ' (' + error.statusCode + ').' +
                        (error.fields != null && error.fields.size() > 0 ?
                                ' Fields ' + String.join(error.fields, ',') + '.' : '' ));
            }
            if (!messages.isEmpty()) {
                throw new CustomMetadataDMLOperationsException(String.join(messages, ' '));
            }
        }
        if (!saveResult.success) {
            throw new CustomMetadataDMLOperationsException('Request failed with no specified error.');
        }
    }

    public class CustomMetadataDMLOperationsException extends Exception {}
}