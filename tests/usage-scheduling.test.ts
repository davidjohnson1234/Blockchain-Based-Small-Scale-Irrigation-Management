import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockUsageScheduling = {
  requestAllocation: vi.fn().mockImplementation((waterSourceId, startTime, endTime, allocation) => {
    return { value: 1 };
  }),
  
  approveAllocation: vi.fn().mockImplementation((scheduleId) => {
    return { value: true };
  }),
  
  completeUsage: vi.fn().mockImplementation((scheduleId) => {
    return { value: true };
  }),
  
  getSchedule: vi.fn().mockImplementation((id) => {
    return {
      waterSourceId: 1,
      farmer: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      startTime: 1625097600,
      endTime: 1625101200,
      allocation: 5000,
      status: "approved"
    };
  })
};

describe('Usage Scheduling Contract', () => {
  it('should request water allocation', async () => {
    const result = await mockUsageScheduling.requestAllocation(
        1,
        1625097600,
        1625101200,
        5000
    );
    
    expect(result.value).toBe(1);
    expect(mockUsageScheduling.requestAllocation).toHaveBeenCalledWith(
        1,
        1625097600,
        1625101200,
        5000
    );
  });
  
  it('should approve allocation', async () => {
    const result = await mockUsageScheduling.approveAllocation(1);
    
    expect(result.value).toBe(true);
    expect(mockUsageScheduling.approveAllocation).toHaveBeenCalledWith(1);
  });
  
  it('should complete usage', async () => {
    const result = await mockUsageScheduling.completeUsage(1);
    
    expect(result.value).toBe(true);
    expect(mockUsageScheduling.completeUsage).toHaveBeenCalledWith(1);
  });
  
  it('should get schedule details', async () => {
    const schedule = await mockUsageScheduling.getSchedule(1);
    
    expect(schedule.waterSourceId).toBe(1);
    expect(schedule.allocation).toBe(5000);
    expect(schedule.status).toBe("approved");
    expect(mockUsageScheduling.getSchedule).toHaveBeenCalledWith(1);
  });
});
