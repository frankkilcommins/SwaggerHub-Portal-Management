# CSharp (C#) Client

A sample client implementation of the pet adoption workflow in csharp.

> This example will demonstrate making requests to the specified operations (`getPets`, `postAdoption`, etc.) with appropriate handling of inputs and outputs. We'll serialize and deserialize JSON manually using `System.Text.Json`, which is included in the `.NET Core` and `.NET 5+` frameworks.

```java
//sample client
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

public class PetAdoptionWorkflow
{
    private readonly HttpClient httpClient = new HttpClient();
    private readonly string token;
    private readonly string location;

    public PetAdoptionWorkflow(string token, string location)
    {
        this.token = token;
        this.location = location;
        httpClient.BaseAddress = new Uri("https://api.swaggerhub.com/apis/");
        httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    }

    public async Task StartWorkflowAsync()
    {
        try
        {
            var availablePets = await GetAvailablePetsAsync();
            if (availablePets == null || availablePets.Length == 0)
            {
                Console.WriteLine("No available pets found.");
                return;
            }

            string petId = availablePets[0].Id;
            var adoptionId = await AdoptPetAsync(petId);
            if (string.IsNullOrEmpty(adoptionId))
            {
                Console.WriteLine("Failed to adopt pet.");
                return;
            }

            bool isAdoptionConfirmed = await ConfirmAdoptionAsync(adoptionId);
            if (!isAdoptionConfirmed)
            {
                Console.WriteLine("Failed to confirm adoption.");
                return;
            }

            bool isPetStatusUpdated = await UpdatePetStatusAsync(petId);
            if (!isPetStatusUpdated)
            {
                Console.WriteLine("Failed to update pet status to 'adopted'.");
                return;
            }

            bool isStatusConfirmed = await ConfirmPetStatusAsync(petId);
            if (!isStatusConfirmed)
            {
                Console.WriteLine("Failed to confirm pet status update.");
                return;
            }

            Console.WriteLine("Pet adoption process completed successfully.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred: {ex.Message}");
        }
    }

    private async Task<Pet[]> GetAvailablePetsAsync()
    {
        string url = "frank-kilcommins/Pets/1.0.0/pet/findByStatus?status=available&location=" + Uri.EscapeDataString(location);
        var response = await httpClient.GetAsync(url);
        response.EnsureSuccessStatusCode();
        string responseContent = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<Pet[]>(responseContent);
    }

    private async Task<string> AdoptPetAsync(string petId)
    {
        string url = "frank-kilcommins/Adoptions/1.0.0/adoptions";
        var adoptionRequest = new
        {
            petId = petId,
            location = this.location
        };
        var jsonContent = new StringContent(JsonSerializer.Serialize(adoptionRequest), Encoding.UTF8, "application/json");
        var response = await httpClient.PostAsync(url, jsonContent);
        response.EnsureSuccessStatusCode();
        string responseContent = await response.Content.ReadAsStringAsync();
        var adoptionResponse = JsonSerializer.Deserialize<dynamic>(responseContent);
        return adoptionResponse?.id;
    }

    private async Task<bool> ConfirmAdoptionAsync(string adoptionId)
    {
        string url = $"frank-kilcommins/Adoptions/1.0.0/adoptions/{adoptionId}";
        var statusUpdate = new
        {
            status = "approved"
        };
        var jsonContent = new StringContent(JsonSerializer.Serialize(statusUpdate), Encoding.UTF8, "application/json");
        var response = await httpClient.PatchAsync(url, jsonContent);
        return response.IsSuccessStatusCode;
    }

    private async Task<bool> UpdatePetStatusAsync(string petId)
    {
        string url = $"frank-kilcommins/Pets/1.0.0/pet/{petId}/status";
        var statusUpdate = new
        {
            status = "adopted"
        };
        var jsonContent = new StringContent(JsonSerializer.Serialize(statusUpdate), Encoding.UTF8, "application/json");
        var response = await httpClient.PatchAsync(url, jsonContent);
        return response.IsSuccessStatusCode;
    }

    private async Task<bool> ConfirmPetStatusAsync(string petId)
    {
        string url = $"frank-kilcommins/Pets/1.0.0/pet/{petId}";
        var response = await httpClient.GetAsync(url);
        response.EnsureSuccessStatusCode();
        string responseContent = await response.Content.ReadAsStringAsync();
        var pet = JsonSerializer.Deserialize<Pet>(responseContent);
        return pet?.Status == "adopted";
    }
}

public class Pet
{
    public string Id { get; set; }
    public string Status { get; set; }
}

class Program
{
    static async Task Main(string[] args)
    {
        string token = "your_api_token_here";
        string location = "your_location_here";
        var workflow = new PetAdoptionWorkflow(token, location);
        await workflow.StartWorkflowAsync();
    }
}
```

