﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Параметры.Свойство("ВидОперации") Тогда
		
		Если Параметры.ВидОперации = "ПоступлениеУслуг" Тогда
			
			Если Не Элементы.Найти("Автор") = Неопределено Тогда
				Колонка3 = ПолучитьКолонку(Элементы, "КолонкаСписка0", Тип("ПолеФормы"), Элементы.Список, Элементы.Автор);
				Колонка3.ПутьКДанным = "Список.СтатьиЗатратСтрока";
				Колонка3.Заголовок = "Статьи затрат";
				Колонка3.Вид = ВидПоляФормы.ПолеНадписи;
				Колонка3.Ширина = 12;
			КонецЕсли;
			
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКолонку(Элементы, ИмяКолонки, ТипКолонки, Владелец, ЭлементРодитель)
	Если ТипЗнч(ЭлементРодитель) = Тип("Строка") Тогда
		Если Элементы.Найти(ЭлементРодитель) = Неопределено Тогда	
			ЭлементРодитель = Неопределено;
		Иначе
			ЭлементРодитель = Элементы[ЭлементРодитель];	
		КонецЕсли;		
	КонецЕсли;
	Тк = Элементы.Найти(ИмяКолонки);
	Если Тк = Неопределено Тогда
		Тк = Элементы.Вставить(ИмяКолонки, ТипКолонки, Владелец, ЭлементРодитель);
	Иначе
		Элементы.Удалить(Тк);
		Тк = Элементы.Вставить(ИмяКолонки, ТипКолонки, Владелец, ЭлементРодитель);
	КонецЕсли;
	Возврат Тк;
	
КонецФункции // ()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Если Параметр.Свойство("ФормаВладелецУИД") И Параметр.ФормаВладелецУИД = ЭтаФорма.УникальныйИдентификатор Тогда
			сабОбщегоНазначения.ПрикрепитьФайлКДокументу(Параметр); 
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
