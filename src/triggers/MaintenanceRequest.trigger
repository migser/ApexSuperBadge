trigger MaintenanceRequest on Case (after update) {
    // call MaintenanceRequestHelper.updateWorkOrders  
    List<Id> ids = new List<ID>();
    for ( Case c : Trigger.new) {
        if (
            (c.Type.equals('Repair')||c.Type.equals('Routine Maintenance'))&&
            c.Status.equals('Closed')&&
            (!Trigger.oldMap.get(c.id).Status.equals('Closed'))
            )
            {
                ids.add(c.id);
            }
       }
    List<Case> requests = [select id , subject, 
                           (select equipment__c, quantity__c,
                            		equipment__r.maintenance_cycle__c
                            from Work_Parts__r)  from case
                          where id in :ids];
    system.debug('Casos a tratar: '+ids);
    system.debug('Info de ls Casos a tratar: '+requests);
    MaintenanceRequestHelper.updateWorkOrders(requests);
    
}