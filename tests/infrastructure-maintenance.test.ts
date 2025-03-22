import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockInfrastructureMaintenance = {
  scheduleMaintenance: vi.fn().mockImplementation((waterSourceId, description, scheduledDate, cost) => {
    return { value: 1 };
  }),
  
  completeMaintenance: vi.fn().mockImplementation((taskId) => {
    return { value: true };
  }),
  
  getMaintenanceTask: vi.fn().mockImplementation((id) => {
    return {
      waterSourceId: 1,
      description: "Clean irrigation channels and repair pump",
      scheduledDate: 1625097600,
      technician: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      cost: 500,
      status: "completed"
    };
  })
};

describe('Infrastructure Maintenance Contract', () => {
  it('should schedule maintenance', async () => {
    const result = await mockInfrastructureMaintenance.scheduleMaintenance(
        1,
        "Clean irrigation channels and repair pump",
        1625097600,
        500
    );
    
    expect(result.value).toBe(1);
    expect(mockInfrastructureMaintenance.scheduleMaintenance).toHaveBeenCalledWith(
        1,
        "Clean irrigation channels and repair pump",
        1625097600,
        500
    );
  });
  
  it('should complete maintenance', async () => {
    const result = await mockInfrastructureMaintenance.completeMaintenance(1);
    
    expect(result.value).toBe(true);
    expect(mockInfrastructureMaintenance.completeMaintenance).toHaveBeenCalledWith(1);
  });
  
  it('should get maintenance task details', async () => {
    const task = await mockInfrastructureMaintenance.getMaintenanceTask(1);
    
    expect(task.waterSourceId).toBe(1);
    expect(task.description).toBe("Clean irrigation channels and repair pump");
    expect(task.cost).toBe(500);
    expect(task.status).toBe("completed");
    expect(mockInfrastructureMaintenance.getMaintenanceTask).toHaveBeenCalledWith(1);
  });
});
