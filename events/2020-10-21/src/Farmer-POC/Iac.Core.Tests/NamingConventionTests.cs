using IacCore;
using NUnit.Framework;

namespace Iac.Core.Tests
{
    [TestFixture]
    public class NamingConventionTests
    {
        [Test]
        public void can_get_resource_group_name()
        {
            var actualValue = NamingConventions.GetResourceGroupName("lab");
            Assert.That(actualValue, Is.EqualTo("iac-lab-rg"));
        }
        
        [Test]
        public void can_get_function_name()
        {
            var actualValue = NamingConventions.GetFunctionName("foobar", "lab");
            Assert.That(actualValue, Is.EqualTo("iac-lab-foobar-func"));
        }
    }
}