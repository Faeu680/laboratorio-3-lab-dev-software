import { Injectable, Logger } from '@nestjs/common';

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

  async sendCoinReceivedEmail(data: CoinReceivedEmailData): Promise<void> {
    // TODO: Implementar integração com serviço de email (SendGrid, AWS SES, etc.)
    this.logger.log(`[EMAIL] Coin received - To: ${data.studentEmail}`);
    this.logger.log(`Subject: Você recebeu ${data.amount} moedas!`);
    this.logger.log(`Body: ${data.studentName}, você recebeu ${data.amount} moedas de ${data.teacherName}.`);
    this.logger.log(`Motivo: ${data.message}`);
  }

  async sendVoucherToStudent(data: VoucherEmailData): Promise<void> {
    // TODO: Implementar integração com serviço de email
    this.logger.log(`[EMAIL] Voucher - To: ${data.recipientEmail}`);
    this.logger.log(`Subject: Seu cupom de resgate - ${data.benefitName}`);
    this.logger.log(`Body: ${data.recipientName}, aqui está seu cupom de resgate!`);
    this.logger.log(`Vantagem: ${data.benefitName}`);
    this.logger.log(`Código do voucher: ${data.voucherCode}`);
    this.logger.log(`Apresente este código na empresa: ${data.companyName}`);
  }

  async sendVoucherToCompany(data: VoucherEmailData): Promise<void> {
    // TODO: Implementar integração com serviço de email
    this.logger.log(`[EMAIL] Voucher notification - To: ${data.recipientEmail}`);
    this.logger.log(`Subject: Nova troca de vantagem - ${data.benefitName}`);
    this.logger.log(`Body: Um aluno resgatou a vantagem: ${data.benefitName}`);
    this.logger.log(`Código do voucher: ${data.voucherCode}`);
    this.logger.log(`Aguarde o aluno apresentar o código para validação.`);
  }
}
