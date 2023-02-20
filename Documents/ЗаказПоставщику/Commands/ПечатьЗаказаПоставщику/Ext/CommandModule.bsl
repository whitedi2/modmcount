﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = ПечатьЗаказаНаСервере(ПараметрКоманды);
		
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.АвтоМасштаб = Истина;   
	
	П = Новый Структура;
	П.Вставить("Ссылка", ПараметрКоманды);
	
	Если НЕ ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЗаголовокФормы = ПараметрКоманды;
	ИначеЕсли ПараметрКоманды.Количество() = 1 Тогда
		РеквизитыЗаявки = ПолучитьНужныеРеквизиты(ПараметрКоманды[0]);
		Организация = РеквизитыЗаявки.Организация;
		П.Вставить("АдресEmail", РеквизитыЗаявки.АдресEmail);
		П.Вставить("Заявка", ПараметрКоманды[0]);
		ЗаголовокФормы = Строка(ПараметрКоманды[0]) + ?(ЗначениеЗаполнено(Организация), " (" + Строка(Организация) + ")", "");
	КонецЕсли; 
	
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента", П);
	ФормаПечати.Результат = ТабДок;
	ФормаПечати.Заголовок = ЗаголовокФормы;
	ФормаПечати.Открыть();
	
КонецПроцедуры

Функция ПечатьЗаказаНаСервере(ПараметрКоманды)
	
	Возврат Документы.ЗаказПоставщику.ПечатьЗаказПоставщику(ПараметрКоманды);
	
КонецФункции

Функция ПолучитьНужныеРеквизиты(ТекЗаявка)
	  Запрос = Новый Запрос;
	  Запрос.Текст = "ВЫБРАТЬ
	                 |	ЗаказПоставщику.Ссылка,
	                 |	КонтрагентыКонтактнаяИнформация.АдресЭП КАК АдресEmail,
	                 |	ЗаказПоставщику.Организация
	                 |ИЗ
	                 |	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	                 |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	                 |		ПО ЗаказПоставщику.Контрагент = КонтрагентыКонтактнаяИнформация.Ссылка
	                 |			И (КонтрагентыКонтактнаяИнформация.Вид.ИдентификаторДляФормул = &ВидКонтактнойИнформации)
	                 |ГДЕ
	                 |	ЗаказПоставщику.Ссылка = &Ссылка";
	  
	  Запрос.УстановитьПараметр("Ссылка", ТекЗаявка);
	  Запрос.УстановитьПараметр("ВидКонтактнойИнформации", "EmailДляЗаказов");
	  
	  Результат = Запрос.Выполнить();
	  Выборка = Результат.Выбрать(); 
	  
	  СписокАдресов = Новый СписокЗначений;
	  
	  Пока Выборка.Следующий() Цикл
	  	Организация = Выборка.Организация;     
	  	СписокАдресов.Добавить(Выборка.АдресEmail); 
	  КонецЦикла;   
	
	Возврат Новый Структура("Организация, АдресEmail", Организация, СписокАдресов); 
 
 КонецФункции // ()
 