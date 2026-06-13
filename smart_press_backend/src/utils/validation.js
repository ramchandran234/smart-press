const Joi = require('joi');

// User validation schemas
const userSchemas = {
  register: Joi.object({
    name: Joi.string().min(2).max(50).required(),
    email: Joi.string().email().required(),
    password: Joi.string().min(6).required(),
    role: Joi.string().valid('owner', 'customer').default('customer'),
    phone: Joi.string().optional(),
    address: Joi.string().optional(),
  }),

  login: Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().required(),
  }),
};

// Order validation schemas
const orderSchemas = {
  create: Joi.object({
    customerId: Joi.string().required(),
    items: Joi.array().items(
      Joi.object({
        service: Joi.string().required(),
        quantity: Joi.number().integer().min(1).required(),
        price: Joi.number().min(0).required(),
      })
    ).min(1).required(),
    totalAmount: Joi.number().min(0).required(),
    pickupDate: Joi.date().required(),
    deliveryDate: Joi.date().optional(),
    notes: Joi.string().optional(),
  }),
};

// Validation middleware
const validate = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, { abortEarly: false });
    if (error) {
      const errors = error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message,
      }));
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors,
      });
    }
    next();
  };
};

module.exports = {
  userSchemas,
  orderSchemas,
  validate,
};