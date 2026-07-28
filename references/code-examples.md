# Refactoring Mechanics — Real Before/After Code

## Extract Method

**Smell:** Long Method with an unclear block that needs a comment to explain it.

```javascript
// BEFORE
function printInvoice(invoice) {
  let total = 0;
  for (const item of invoice.items) {
    total += item.price * item.quantity;
  }
  // print banner
  console.log('***********************');
  console.log(`* Invoice for ${invoice.customer} *`);
  console.log('***********************');
  console.log(`Total: $${total}`);
}

// AFTER
function printInvoice(invoice) {
  const total = calculateTotal(invoice);
  printBanner(invoice.customer);
  console.log(`Total: $${total}`);
}

function calculateTotal(invoice) {
  return invoice.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

function printBanner(customerName) {
  console.log('***********************');
  console.log(`* Invoice for ${customerName} *`);
  console.log('***********************');
}
```
The comment `// print banner` disappeared because the extracted method's name now says the same thing.

---

## Replace Temp with Query

**Smell:** A local variable computed once and referenced several times, making the method longer than it needs to be and hiding a reusable calculation.

```java
// BEFORE
double calculateTotal(Order order) {
    double basePrice = order.quantity * order.itemPrice;
    if (basePrice > 1000) {
        return basePrice * 0.95;
    } else {
        return basePrice * 0.98;
    }
}

// AFTER
double calculateTotal(Order order) {
    if (basePrice(order) > 1000) {
        return basePrice(order) * 0.95;
    } else {
        return basePrice(order) * 0.98;
    }
}

double basePrice(Order order) {
    return order.quantity * order.itemPrice;
}
```

---

## Replace Conditional with Polymorphism

**Smell:** Switch Statements / type-code branching that repeats across multiple methods.

```typescript
// BEFORE
function getSpeed(bird: Bird): number {
  switch (bird.type) {
    case 'EUROPEAN':
      return 35;
    case 'AFRICAN':
      return 40 - bird.numberOfCoconuts * 2;
    case 'NORWEGIAN_BLUE':
      return bird.isNailed ? 0 : 10 + bird.voltage / 10;
    default:
      throw new Error('Unknown bird type');
  }
}

// AFTER
abstract class Bird {
  abstract getSpeed(): number;
}

class European extends Bird {
  getSpeed(): number { return 35; }
}

class African extends Bird {
  constructor(private numberOfCoconuts: number) { super(); }
  getSpeed(): number { return 40 - this.numberOfCoconuts * 2; }
}

class NorwegianBlue extends Bird {
  constructor(private isNailed: boolean, private voltage: number) { super(); }
  getSpeed(): number { return this.isNailed ? 0 : 10 + this.voltage / 10; }
}
```
The `switch` disappears entirely — each subtype knows its own speed calculation. If this switch appeared in three other methods (`getPlumage`, `getMigrationPattern`), those collapse the same way, which is the real payoff — a single switch replaced once is a modest win; the same switch scattered across a codebase is where this mechanic earns its cost.

---

## Introduce Parameter Object

**Smell:** Long Parameter List, especially when the same group of parameters travels together across several methods.

```python
# BEFORE
def create_booking(guest_name, guest_email, check_in_date, check_out_date, room_number, num_guests):
    ...

def cancel_booking(guest_name, guest_email, check_in_date, check_out_date, room_number):
    ...

# AFTER
@dataclass
class BookingDetails:
    guest_name: str
    guest_email: str
    check_in_date: date
    check_out_date: date
    room_number: int

def create_booking(details: BookingDetails, num_guests: int):
    ...

def cancel_booking(details: BookingDetails):
    ...
```

---

## Move Method (fixing Feature Envy)

**Smell:** A method that uses another class's data more than its own.

```csharp
// BEFORE — this method lives on Order but is obsessed with Customer's data
class Order {
    public decimal GetDiscountedPrice() {
        if (this.Customer.YearsAsMember > 5 && this.Customer.TotalOrders > 100) {
            return this.Price * 0.8m;
        }
        return this.Price;
    }
}

// AFTER — moved to where the data actually lives
class Customer {
    public bool QualifiesForLoyaltyDiscount() {
        return this.YearsAsMember > 5 && this.TotalOrders > 100;
    }
}

class Order {
    public decimal GetDiscountedPrice() {
        return this.Customer.QualifiesForLoyaltyDiscount() ? this.Price * 0.8m : this.Price;
    }
}
```

---

## Executable test proving behavior didn't change (characterization-style)

```javascript
// Before touching printInvoice above, a test like this locks the current behavior in place
describe('printInvoice', () => {
  it('prints the same total for the same invoice, before and after refactoring', () => {
    const invoice = { customer: 'Acme Co', items: [{ price: 10, quantity: 3 }] };
    const consoleSpy = jest.spyOn(console, 'log');
    printInvoice(invoice);
    expect(consoleSpy).toHaveBeenCalledWith('Total: $30');
  });
});
```
Run this test, confirm it passes, refactor, run it again — same assertion, same result, is the concrete meaning of "observable behavior preserved."
