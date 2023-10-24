public with sharing class customDataTableController {

    @AuraEnabled
    public static List<sObject> getData (String objectApiName, String fields){
        String query = String.format('SELECT Id, {0} FROM {1} LIMIT 10', new List<String>{
            fields.replace(';',', '), objectApiName
        });
        return Database.query(query);   
    }

    @AuraEnabled
    public static Map<String, Object>  getTableInformation(String objectApiName, String fields){
        List<ColumnWrapper> columns = new List<ColumnWrapper>();

        String fieldReplase = fields.replace(';',', ');
        List<String> fieldList = fields.split(';'); 
        Map<String,Schema.SObjectField> objectDescribe = getObjectDescribe(objectApiName);

        for (String field : fieldList) {
            Schema.DescribeFieldResult fieldInformation = objectDescribe.get(field).getDescribe();
            Schema.DisplayType apexFieldType = fieldInformation.getType();
            
            switch on apexFieldType {
                when PICKLIST { 
                    columns.add(new ColumnWrapper(field, 'picklistColumn', false, new TypeAttributes(field, getPicklistOptions(fieldInformation), 'Choose' + field, 'Id')));
                }
                when STRING {
                    columns.add(new ColumnWrapper(field, 'text', true, null));
                }
                when else { 
                    columns.add(new ColumnWrapper(field, null, true, null));               
                 }
            }
        }

        return new Map<String, Object> {
            'columns' => columns,
            'data' => getData(objectApiName, fields)
        };
    }

    private static List<Map<String, String>> getPicklistOptions (Schema.DescribeFieldResult fieldInformation) {
        List<Map<String, String>> picklistOptions = new List<Map<String, String>>();

        for( Schema.PicklistEntry pickList : fieldInformation.getPicklistValues()){
            Map<String, String> picklistOption = new Map<String, String>();
            picklistOption.put('label', pickList.getLabel());
            picklistOption.put('value', pickList.getValue());
           
            picklistOptions.add(picklistOption);
        }     

        return picklistOptions;
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


        private columnWrapper (String fieldName, String type, Boolean editable, TypeAttributes typeAttributes) {
            this.label = fieldName;
            this.fieldName = fieldName;
            this.editable = editable;
            this.type = type;
            this.typeAttributes = typeAttributes;
        } 
    }

    public class TypeAttributes { 
        @AuraEnabled public String placeholder;
        @AuraEnabled public String name;
        @AuraEnabled public String fieldName;
        @AuraEnabled public List<Map<String, String>> options;
        @AuraEnabled public Map<String, String> value;
        @AuraEnabled public Map<String, String> context;
        @AuraEnabled public List<Map<String, String>> picklistOptions;

       private typeAttributes (String fieldName, List<Map<String, String>> picklistOptions, String placeholder, String context) {
            this.placeholder = placeholder;
            this.value = new Map<String, String> {'fieldName' => fieldName};
            this.options = picklistOptions;
            this.context = new Map<String, String> {'fieldName' => context};
            this.name = fieldName;
            this.fieldName =  fieldName;
        }
    }
}