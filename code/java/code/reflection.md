# reflection

## 反射获取Object key和value

```java
Object o = this.getSession().load(entity.getClass(), pk);
List<Field> field = BeanUtils.getDeclaredFields(entity.getClass());
Iterator var9 = field.iterator();

while (var9.hasNext()) {
    Field property = (Field) var9.next();
    if (!property.getName().equals(pkName)) {
        Object value = BeanUtils.getFieldValue(entity, property.getName());
        if (value != null) {
            Method setter = BeanUtils.getSetter(entity.getClass(), property);
            setter.invoke(o, value);
        }
    }
}
```
