 # Typescript Client

A sample client implementation of the pet adoption workflow in typescript.

> This example will demonstrate how to sequentially execute the workflow steps: searching for available pets, adopting a pet, confirming the adoption, updating the pet's status to "adopted", and confirming the pet's new status. It will include JSON handling for requests and responses.

> ⚠️ Ensure you have the necessary environment to run TypeScript code, including having `node-fetch` installed for server-side fetch functionality if running outside a browser context

```typescript
// Assuming node environment. If using in a browser, fetch is globally available.
import fetch from 'node-fetch';

interface Pet {
  id: string;
  status?: string;
  name?: string;
}

class PetAdoptionWorkflow {
  private readonly token: string;
  private readonly location: string;
  private readonly petsApiBaseUrl = 'https://api.swaggerhub.com/apis/frank-kilcommins/Pets/1.0.0';
  private readonly adoptionsApiBaseUrl = 'https://api.swaggerhub.com/apis/frank-kilcommins/Adoptions/1.0.0';

  constructor(token: string, location: string) {
    this.token = token;
    this.location = location;
  }

  public async startWorkflow(): Promise<void> {
    try {
      const availablePets = await this.getAvailablePets();
      if (availablePets.length === 0) {
        console.log('No available pets found.');
        return;
      }

      const petId = availablePets[0].id;
      const adoptionId = await this.adoptPet(petId);
      if (!adoptionId) {
        console.log('Failed to adopt pet.');
        return;
      }

      const isAdoptionConfirmed = await this.confirmAdoption(adoptionId);
      if (!isAdoptionConfirmed) {
        console.log('Failed to confirm adoption.');
        return;
      }

      const isPetStatusUpdated = await this.updatePetStatus(petId);
      if (!isPetStatusUpdated) {
        console.log("Failed to update pet's status to 'adopted'.");
        return;
      }

      const isStatusConfirmed = await this.confirmPetStatus(petId);
      if (!isStatusConfirmed) {
        console.log("Failed to confirm pet's status update.");
        return;
      }

      console.log('Pet adoption process completed successfully.');
    } catch (error) {
      console.error('An error occurred during the pet adoption workflow:', error);
    }
  }

  private async getAvailablePets(): Promise<Pet[]> {
    const response = await fetch(`${this.petsApiBaseUrl}/pet/findByStatus?status=available&location=${encodeURIComponent(this.location)}`, {
      headers: {
        'Authorization': `Bearer ${this.token}`,
      },
    });
    if (!response.ok) {
      throw new Error('Failed to fetch available pets');
    }
    return response.json();
  }

  private async adoptPet(petId: string): Promise<string | null> {
    const response = await fetch(`${this.adoptionsApiBaseUrl}/adoptions`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        pets: [petId],
        location: this.location,
      }),
    });
    if (!response.ok) {
      return null;
    }
    const data = await response.json();
    return data.adoptionId;
  }

  private async confirmAdoption(adoptionId: string): Promise<boolean> {
    const response = await fetch(`${this.adoptionsApiBaseUrl}/adoptions/${adoptionId}`, {
      method: 'PATCH',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ status: 'approved' }),
    });
    return response.ok;
  }

  private async updatePetStatus(petId: string): Promise<boolean> {
    const response = await fetch(`${this.petsApiBaseUrl}/pet/${petId}/status`, {
      method: 'PATCH',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ status: 'adopted' }),
    });
    return response.ok;
  }

  private async confirmPetStatus(petId: string): Promise<boolean> {
    const response = await fetch(`${this.petsApiBaseUrl}/pet/${petId}`, {
      headers: {
        'Authorization': `Bearer ${this.token}`,
      },
    });
    if (!response.ok) {
      return false;
    }
    const pet: Pet = await response.json();
    return pet.status === 'adopted';
  }
}

// Example usage:
const token = 'YOUR_API_TOKEN';
const location = 'YOUR_LOCATION';
const workflow = new PetAdoptionWorkflow(token, location);

workflow.startWorkflow().then(() => {
  console.log('Workflow completed.');
}).catch(console.error);

```

This TypeScript example is structured to execute in a Node.js environment but can be easily adapted for browser use by removing the node-fetch import (as fetch is available globally in browsers). Remember to replace `YOUR_API_TOKEN` and `YOUR_LOCATION` with actual values. 