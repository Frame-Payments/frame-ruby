## [Unreleased]

## [0.1.0] - 2025-03-11

### Added

#### Core Features
- Complete Ruby SDK for Frame Payments API
- Thread-safe client initialization
- Comprehensive error handling with specific error types
- SSL certificate verification (enabled by default)
- API key validation
- Configurable timeouts and connection settings
- Optional request/response logging with sensitive data redaction

#### API Resources
- **Customers**: Create, retrieve, update, delete, list, search, block, and unblock customers
- **Charge Intents**: Create, retrieve, update, list, authorize, capture, and cancel charge intents
- **Payment Methods**: Create, retrieve, update, delete, list, attach, and detach payment methods
- **Refunds**: Create, retrieve, list, and cancel refunds
- **Invoices**: Create, retrieve, update, delete, list, finalize, pay, and void invoices
- **Invoice Line Items**: Create, retrieve, update, delete, and list invoice line items
- **Subscriptions**: Create, retrieve, update, delete, list, cancel, pause, and resume subscriptions
- **Subscription Phases**: Create, retrieve, update, delete, and list subscription phases
- **Products**: Create, retrieve, update, delete, and list products
- **Product Phases**: Create, retrieve, update, delete, and list product phases
- **Webhook Endpoints**: Create, retrieve, update, delete, list, enable, and disable webhook endpoints
- **Customer Identity Verifications**: Create, retrieve, list, and verify customer identity verifications

#### Features
- Dynamic attribute access for all API response fields
- Automatic object type conversion from API responses
- Pagination support for list endpoints
- Comprehensive test suite with 100+ tests
- Full documentation with examples for all resources
- Error handling with detailed error information

### Security
- SSL certificate verification enabled by default
- API key validation before requests
- Sensitive data redaction in logs (API keys, card numbers, etc.)
- Secure handling of authentication headers

### Documentation
- Complete README with usage examples for all resources
- YARD-style documentation comments
- Error handling examples
- Configuration examples
