import { applyDecorators } from '@nestjs/common';
import { ApiExtraModels, ApiResponse, getSchemaPath } from '@nestjs/swagger';

export function ApiWrappedResponse(options: {
  status?: number;
  // biome-ignore lint/suspicious/noExplicitAny: can be any
  type?: any;
  isArray?: boolean;
  description?: string;
}) {
  const { status = 200, type, isArray = false, description } = options;

  const decorators = [ApiResponse({ status, description })];

  if (type) {
    decorators.push(ApiExtraModels(type));

    decorators.push(
      ApiResponse({
        status,
        description,
        schema: {
          type: 'object',
          properties: {
            data: isArray
              ? {
                  type: 'array',
                  items: { $ref: getSchemaPath(type) },
                }
              : { $ref: getSchemaPath(type) },
          },
          required: ['data'],
        },
      })
    );
  }

  return applyDecorators(...decorators);
}
