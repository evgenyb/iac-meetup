namespace IacCore
{
    
    public static class NamingConventions
    {
        const string Prefix = "iac";
        
        public static string GetResourceGroupName(string environment)
        {
            return $"{Prefix}-{environment}-rg";
        }
        
        public static string GetStorageAccountName(string saType, string environment)
        {
            return $"{Prefix}{environment}{saType}sa";
        }
        
        public static string GetFunctionName(string funcName, string environment)
        {
            return $"{Prefix}-{environment}-{funcName}-func";
        } 
        
        public static string GetServicePlanName(string environment)
        {
            return $"{Prefix}-{environment}-sp";
        }
    }
}