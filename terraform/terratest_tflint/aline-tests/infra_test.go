package aline-tests

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type DataStruct struct{
	vpcName	string `json:"vpcName"`
	gatewayName	string `json:"gatewayName"`
	peeringName	string `json:"peeringName"`
}

var ExpectedValues DataStruct

func init(){
	jsonFile, err := os.Open("./infra_testdata.json")
	if err != nil{
		fmt.Println(err)
	}
	byteValue, _ := ioutil.ReadAll(jsonFile)
	json.Unmarshal(byteValue, &ExpectedValues)
}

func TestAlineInfra(t *testing.T){
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../dev/deploy/networking",
		VarFiles: []string{"terraform.tfvars"},
		NoColor: true,
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-west-1"
		}
	})
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	actualVPCName := terraform.terraform.Output(t, terraformOptions, "")
	actualGatewayName := terraform.terraform.Output(t, terraformOptions, "")
	actualPeeringName := terraform.terraform.Output(t, terraformOptions, "")
	assert.Equal(t, ExpectedValues.vpcName, actualVPCName)
	assert.Equal(t, ExpectedValues.gatewayName, actualGatewayName)
	assert.Equal(t, ExpectedValues.peeringName, actualPeeringName)
}