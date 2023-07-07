public with sharing class customDataTableController {

    @AuraEnabled
    public static List<sObject> getDataTable(String objectApiName, String fields){
        String query = 'SELECT ' + fields.replace(';',', ') + ' FROM ' + objectApiName + ' LIMIT 10';
        List<sObject> records =  Database.query(query);
        return records;     
    }

    @AuraEnabled
    public static String getColumnTable(String objectApiName, String fields){
        List<ColumnWrapper> column = new  List<ColumnWrapper>();
        for (String field : fields.split(';')) {
            Schema.DescribeFieldResult fieldDescribe = getFieldDescribe(objectApiName, field);
            String fieldType = String.valueOf(fieldDescribe.getType());

            if (fieldType == 'PICKLIST') {
                Map<String, List<Schema.PicklistEntry>> picklistOptions = new Map<String, List<Schema.PicklistEntry>>();
            
                picklistOptions.put(field +  + '_options', fieldDescribe.getPicklistValues());
                column.add(new ColumnWrapper(objectApiName, field, 'picklistColumn', new TypeAttributes(field, picklistOptions)));
            } else if (fieldType == 'STRING') {
                column.add(new ColumnWrapper(objectApiName, field, 'text', null));
            } else {
                column.add(new ColumnWrapper(objectApiName, field, fieldType.toLowerCase(), null));
            }
        }

        return JSON.serialize(column);  
    }

    private static Schema.DescribeFieldResult getFieldDescribe (String objectName, String fieldName) {             
        return Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .fields.getMap()
            .get(fieldName)
            .getDescribe();
    }

    private class ColumnWrapper {
        String label;
        String fieldName;
        String type;
        Boolean editable;
        TypeAttributes typeAttributes;


        private columnWrapper(String objectName, String fieldName, String type, TypeAttributes typeAttributes) {
            this.label = fieldName;
            this.fieldName = fieldName;
            this.editable = true;
            this.type = type;
            this.typeAttributes = typeAttributes;
        } 
    }

    private class TypeAttributes { 
        String placeholder;
        FieldName options;
        FieldName value;
        FieldName context;
        Map<String, List<Schema.PicklistEntry>> picklistoptions;

        private typeAttributes(String fieldName, Map<String, List<Schema.PicklistEntry>> picklistoptions) {
            this.placeholder = 'Choose Type';
            this.value = new FieldName(fieldName);
            this.options = new FieldName(fieldName + '_options');
            this.context = new FieldName('Id');
            this.picklistoptions = picklistoptions;
        }
    }

    private class FieldName {
        String fieldName;

        private fieldName(String fieldName) {
            this.fieldName = fieldName;
        }
    }
}
