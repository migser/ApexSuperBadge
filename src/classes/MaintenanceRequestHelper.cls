public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> requests){
        List<Case> nuevos = new List<Case>();
        List<Work_Part__c> n_partes = new List<Work_Part__c>();
        for (Case c : requests) {
			Case n = new Case (Subject = 'Revisión Preventiva', Type='Routine Maintenance', 
                               Date_Reported__c =system.today(),  Origin='Web');	
            Decimal min = 0;
            
            for (Work_Part__c wp : c.Work_Parts__r) {
                if (min==0||wp.equipment__r.maintenance_cycle__c<min) {
                    min=wp.equipment__r.maintenance_cycle__c;
                }
                system.debug('Insertando WP, ID del caso = '+n.id);
             Work_Part__c nuevo_wp = New Work_Part__c (
			                 		equipment__c=wp.equipment__c,
                 					quantity__c=wp.quantity__c
             							);
          //   nuevo_wp.maintenance_request__c = c;
             n_partes.add(nuevo_wp);
            }
            c.Date_Due__c=system.today().addDays(Integer.valueof(min));
            
            
            
            nuevos.add(n);
        }
        insert nuevos;
        for (Work_part__c wp : n_partes) {
            wp.maintenance_request__c = nuevos[integer.valueof(wp.Maintenance_Request__c)].id;
        }
        insert n_partes;
    }        
    
}