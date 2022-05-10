package alinetests

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"testing"
	"time"

	// "github.com/gruntwork-io/terratest/modules/aws"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type DataStruct struct {
	VpcName     string `json:"vpcName"`
	GatewayName string `json:"gatewayName"`
	PeeringName string `json:"peeringName"`
}

var ExpectedValues DataStruct

func init() {
	jsonFile, err := os.Open("./infra_testdata.json")
	if err != nil {
		fmt.Println(err)
	}
	byteValue, _ := ioutil.ReadAll(jsonFile)
	json.Unmarshal(byteValue, &ExpectedValues)
}

func TestAlineInfra(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../aline-infra-my/dev/deploy/networking",
		VarFiles:     []string{"terraform.tfvars"},
		NoColor:      true,
	})
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	actualVPCName := terraform.Output(t, terraformOptions, "vpc_name")
	t.Logf("Expected VPC Name: %s - Actual VPC Name: %s", ExpectedValues.VpcName, actualVPCName)
	assert.Equal(t, ExpectedValues.VpcName, actualVPCName)

	actualGatewayName := terraform.Output(t, terraformOptions, "gateway_name")
	t.Logf("Expected Gateway Name: %s - Actual Gateway Name: %s", ExpectedValues.GatewayName, actualGatewayName)
	assert.Equal(t, ExpectedValues.GatewayName, actualGatewayName)

	actualPeeringName := terraform.Output(t, terraformOptions, "peering_name")
	t.Logf("Expected Peering Connection Name: %s - Actual Peering Connection Name: %s", ExpectedValues.PeeringName, actualPeeringName)
	assert.Equal(t, ExpectedValues.PeeringName, actualPeeringName)

	bastionIP := terraform.Output(t, terraformOptions, "bastion_ip")
	bastionURL := fmt.Sprintf("http://%s:8080", bastionIP)
	t.Logf("Testing connection to %s", bastionURL)
	http_helper.HttpGetWithRetry(t, bastionURL, nil, 200, "Hello World", 30, 5*time.Second)
}
