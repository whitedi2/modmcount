﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ТипОбеспечения = Перечисления.ТипыОбеспеченияПотребности.ПриДостиженииТочкиЗаказа;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	СформироватьАвтоНаименование();
	ВыбранныйЭлемент = ВыбратьИзСписка(Элементы.Наименование.СписокВыбора, Элемент);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.Наименование = ВыбранныйЭлемент.Значение;
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьАвтоНаименование()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	Если Объект.ГрафикЗаказовПоставок.Количество() > 0 Тогда
		СтокаБезПодразделений = Объект.ГрафикЗаказовПоставок[0];
		СтрокаНаименованияОбщая = "Заказы " + СтокаБезПодразделений.ДеньНеделиЗаказа + " (" + СтокаБезПодразделений.ЧетностьЗаказа + ") / поставки " + СтокаБезПодразделений.ДеньНеделиПоставки + " (" + СтокаБезПодразделений.ЧетностьПоставки + ")";
	Иначе
	    СтрокаНаименованияОбщая = "Общая по " + Объект.ИсточникОбеспечения;
	КонецЕсли;	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименованияОбщая);
			
	Возврат СтрокаНаименованияОбщая;
	
КонецФункции	

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
		Наименование = СформироватьАвтоНаименование();
	КонецЕсли;	
	
КонецПроцедуры
