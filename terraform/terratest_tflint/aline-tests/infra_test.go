package alinetests

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"testing"

	// "github.com/gruntwork-io/terratest/modules/aws"
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
	actualGatewayName := terraform.Output(t, terraformOptions, "gateway_name")
	actualPeeringName := terraform.Output(t, terraformOptions, "peering_name")
	actualBastionID := terraform.Output(t, terraformOptions, "bastion_info")
	assert.Equal(t, ExpectedValues.VpcName, actualVPCName)
	assert.Equal(t, ExpectedValues.GatewayName, actualGatewayName)
	assert.Equal(t, ExpectedValues.PeeringName, actualPeeringName)
	assert.NotNil(t, actualBastionID)
}
