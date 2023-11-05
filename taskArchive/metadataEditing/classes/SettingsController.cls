public with sharing class SettingsController {

    @AuraEnabled(Cacheable=true)
    public static SettingsService.MetadataResultDTO getSettings() {
        return SettingsService.newInstance().prepareSettings();
    }
    
    @AuraEnabled(Cacheable=true)
    public static void updateSettings(String metadataText, String label) {
        //system.debug('settingsData===' + JSON.serialize(metadataText, label));
        SettingsService.newInstance().updateSettings(metadataText, label);
    }
}