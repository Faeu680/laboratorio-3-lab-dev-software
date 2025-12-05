import { Test, TestingModule } from '@nestjs/testing';
import { MailService } from './mail.service';
import { Resend } from 'resend';

// Mock Resend
jest.mock('resend', () => {
  return {
    Resend: jest.fn().mockImplementation(() => ({
      emails: {
        send: jest.fn().mockResolvedValue({ id: 'mock-id' }),
      },
    })),
  };
});

// Mock env
jest.mock('../config/env', () => ({
  env: {
    RESEND_API_KEY: 'mock-api-key',
    MAIL_FROM: 'mock@example.com',
  },
}));

describe('MailService', () => {
  let service: MailService;
  let resendMock: any;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MailService],
    }).compile();

    service = module.get<MailService>(MailService);
    resendMock = (service as any).resend;
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('sendCoinReceivedEmail', () => {
    it('should send an email with correct parameters', async () => {
      const data = {
        studentEmail: 'student@example.com',
        studentName: 'Student',
        teacherName: 'Teacher',
        amount: 100,
        message: 'Great job!',
      };

      await service.sendCoinReceivedEmail(data);

      expect(resendMock.emails.send).toHaveBeenCalledWith(
        expect.objectContaining({
          to: data.studentEmail,
          subject: `Você recebeu ${data.amount} moedas!`,
          html: expect.stringContaining(data.studentName),
        })
      );
    });
  });

  describe('sendVoucherToStudent', () => {
    it('should send an email with correct parameters', async () => {
      const data = {
        recipientEmail: 'student@example.com',
        recipientName: 'Student',
        benefitName: 'Benefit',
        voucherCode: 'CODE123',
        companyName: 'Company',
      };

      await service.sendVoucherToStudent(data);

      expect(resendMock.emails.send).toHaveBeenCalledWith(
        expect.objectContaining({
          to: data.recipientEmail,
          subject: `Seu cupom de resgate - ${data.benefitName}`,
          html: expect.stringContaining(data.voucherCode),
        })
      );
    });
  });

  describe('sendVoucherToCompany', () => {
    it('should send an email with correct parameters', async () => {
      const data = {
        recipientEmail: 'company@example.com',
        recipientName: 'Company',
        benefitName: 'Benefit',
        voucherCode: 'CODE123',
        companyName: 'Company',
      };

      await service.sendVoucherToCompany(data);

      expect(resendMock.emails.send).toHaveBeenCalledWith(
        expect.objectContaining({
          to: data.recipientEmail,
          subject: `Nova troca de vantagem - ${data.benefitName}`,
          html: expect.stringContaining(data.voucherCode),
        })
      );
    });
  });
});
