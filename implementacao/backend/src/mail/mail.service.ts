import { Injectable, Logger } from '@nestjs/common';
import { Resend } from 'resend';
import { env } from '../config/env';

export interface CoinReceivedEmailData {
  studentEmail: string;
  studentName: string;
  teacherName: string;
  amount: number;
  message: string;
}

export interface VoucherEmailData {
  recipientEmail: string;
  recipientName: string;
  benefitName: string;
  voucherCode: string;
  companyName: string;
}

@Injectable()
export class MailService {
  private readonly logger = new Logger(MailService.name);
  private readonly resend = new Resend(env.RESEND_API_KEY);

  async sendCoinReceivedEmail(data: CoinReceivedEmailData): Promise<void> {
    try {
      await this.resend.emails.send({
        from: env.MAIL_FROM,
        to: data.studentEmail,
        subject: `Você recebeu ${data.amount} moedas!`,
        html: `
          <h1>Olá ${data.studentName},</h1>
          <p>Você recebeu <strong>${data.amount} moedas</strong> de ${data.teacherName}.</p>
          <p><strong>Motivo:</strong> ${data.message}</p>
        `,
      });
      this.logger.log(`[EMAIL] Coin received sent to ${data.studentEmail}`);
    } catch (error) {
      this.logger.error(
        `[EMAIL] Failed to send coin received email to ${data.studentEmail}`,
        error
      );
    }
  }

  async sendVoucherToStudent(data: VoucherEmailData): Promise<void> {
    try {
      await this.resend.emails.send({
        from: env.MAIL_FROM,
        to: data.recipientEmail,
        subject: `Seu cupom de resgate - ${data.benefitName}`,
        html: `
          <h1>Olá ${data.recipientName},</h1>
          <p>Aqui está seu cupom de resgate para a vantagem: <strong>${data.benefitName}</strong></p>
          <p><strong>Código do voucher:</strong> ${data.voucherCode}</p>
          <p>Apresente este código na empresa: <strong>${data.companyName}</strong></p>
        `,
      });
      this.logger.log(`[EMAIL] Voucher sent to student ${data.recipientEmail}`);
    } catch (error) {
      this.logger.error(`[EMAIL] Failed to send voucher to student ${data.recipientEmail}`, error);
    }
  }

  async sendVoucherToCompany(data: VoucherEmailData): Promise<void> {
    try {
      await this.resend.emails.send({
        from: env.MAIL_FROM,
        to: data.recipientEmail,
        subject: `Nova troca de vantagem - ${data.benefitName}`,
        html: `
          <h1>Olá,</h1>
          <p>Um aluno resgatou a vantagem: <strong>${data.benefitName}</strong></p>
          <p><strong>Código do voucher:</strong> ${data.voucherCode}</p>
          <p>Aguarde o aluno apresentar o código para validação.</p>
        `,
      });
      this.logger.log(`[EMAIL] Voucher notification sent to company ${data.recipientEmail}`);
    } catch (error) {
      this.logger.error(
        `[EMAIL] Failed to send voucher notification to company ${data.recipientEmail}`,
        error
      );
    }
  }
}
