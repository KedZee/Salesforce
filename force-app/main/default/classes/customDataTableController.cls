public with sharing class customDataTableController {

    @AuraEnabled
    public static List<sObject> getData (String objectApiName, String fields){
        String query = String.format('SELECT Id, {0} FROM {1} LIMIT 10', new List<String>{
            fields.replace(';',', '), objectApiName
        });
        return Database.query(query);   
    }

    @AuraEnabled
    public static Map<String, Object> getDataTableInformation (String objectApiName, String fields){
        List<ColumnWrapper> columns = new List<ColumnWrapper>();
        Map<String, Object> dataOptions = new Map<String, Object>();
        Map<String, Object> result = new Map<String, Object>();

        String fieldReplase = fields.replace(';',', ');
        List<String> fieldList = fields.split(';'); 
        Map<String,Schema.SObjectField> objectDescribe = getObjectDescribe(objectApiName);

        for (String field : fieldList) {
            Schema.DescribeFieldResult fieldInformation = objectDescribe.get(field).getDescribe();
            Schema.DisplayType apexFieldType = fieldInformation.getType();
            
            switch on apexFieldType {
                when PICKLIST { 
                    List<Map<String, String>> picklistOptions = new List<Map<String, String>>();

                    for( Schema.PicklistEntry pickList : fieldInformation.getPicklistValues()){
                        Map<String, String> picklistOption = new Map<String, String>();
                        picklistOption.put('label', pickList.getLabel());
                        picklistOption.put('value', pickList.getValue());
                       
                        picklistOptions.add(picklistOption);
                    }     
    
                    dataOptions.put(field, picklistOptions);
                    columns.add(new ColumnWrapper(field, 'picklistColumn', new TypeAttributes(field, 'Choose' + field, 'Id')));
                }
                when STRING {
                    dataOptions.put(field, null);
                    columns.add(new ColumnWrapper(field, 'text', null));
                }
                when else { 
                    dataOptions.put(field, null);
                    columns.add(new ColumnWrapper(field, null, null));               
                 }
            }
        }

        List<Map<String, Object>> finalyData = new List<Map<String, Object>>();

        for(sObject record: getData(objectApiName, fields)) {
            Map<String, Object> data = new Map<String, Object>();
            
            data.put('Id', record.Id);

            for(String field : dataOptions.keySet()){
                data.put(field, record.get(field)); 
                data.put(field + '_piskListOptions', dataOptions.get(field)); 
            }
            finalyData.add(data);

        }
        result.put('data', finalyData);
        result.put('columns', columns);

        return result;  
    }

    private static Map<String,Schema.SObjectField> getObjectDescribe (String objectName) {             
        return Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .fields.getMap();
    }

    public class ColumnWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String type;
        @AuraEnabled public Boolean editable;
        @AuraEnabled public TypeAttributes typeAttributes;


        private columnWrapper (String fieldName, String type, TypeAttributes typeAttributes) {
            this.label = fieldName;
            this.fieldName = fieldName;
            this.editable = true;
            this.type = type;
            this.typeAttributes = typeAttributes;
        } 
    }

    public class TypeAttributes { 
        @AuraEnabled public String placeholder;
        @AuraEnabled public Map<String, String> options;
        @AuraEnabled public Map<String, String>  value;
        @AuraEnabled public Map<String, String>  context;

       private typeAttributes (String fieldName, String placeholder, String context) {
            this.placeholder = placeholder;
            this.value = new Map<String, String> {'fieldName' => fieldName};
            this.options = new Map<String, String> {'fieldName' => fieldName + '_piskListOptions'};
            this.context = new Map<String, String> {'fieldName' => context};
        }
    }
}